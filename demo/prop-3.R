suppressPackageStartupMessages(library(largeScaleR, verbose=FALSE))
host <- paste0("10.3.1.", 
                rep(c("hadoop1"=17, "hadoop2"=2, "hadoop3"=5, "hadoop4"=3,
                      "hadoop5"=15, "hadoop6"=8, "hadoop7"=7, "hadoop8"=9),
                    each=4))
cols <- c("vendor_id"="character",
                "pickup_datetime"="POSIXct",
                "dropoff_datetime"="POSIXct",
                "passenger_count"="integer",
                "trip_distance"="numeric",
                "pickup_longitude"="numeric",
                "pickup_latitude"="numeric",
                "rate_code"="integer",
                "store_and_fwd_flag"="character",
                "dropoff_longitude"="numeric",
                "dropoff_latitude"="numeric",
                "payment_type"="character",
                "fare_amount"="numeric",
                "surcharge"="numeric",
                "mta_tax"="numeric",
                "tip_amount"="numeric",
                "tolls_amount"="numeric",
                "total_amount"="numeric")
file <- paste0("~/taxicab-", formatC(seq(0, (8*4)-1),width=2,flag=0), ".csv")

start(workers=host, loginName="hadoop", 
    user="10.1.0.70", comms="10.3.1.1", log="10.3.1.1")

taxicab <- read.dlcsv(host, file, col.names=names(cols), colClasses=cols)
print(taxicab)
preview(taxicab)

nrow(taxicab)

totaltips <- taxicab$tip_amount
sum(totaltips, na.rm=T)

dsum <- do.dcall("sum", list(totaltips, na.rm=I(TRUE)))
lsum <- emerge(dsum)
sum(lsum)

library(fastshp)

zs <- fastshp::read.shp("cb_2018_us_zcta510_500k.shp", format="poly")
zi <- do.dcall(function(long, lat)
	       fastshp::inside(fastshp::read.shp("cb_2018_us_zcta510_500k.shp",
						 format="poly"), long, lat),
	       list(long=taxicab$pickup_longitude,
		    lat=taxicab$pickup_latitude))

zdb <- foreign::read.dbf("~/cb_2018_us_zcta510_500k.dbf", as.is=TRUE)

zc <- table(zi)
zc <- zc[zc > 20]

xl <- range(sapply(zs[as.integer(names(zc))], function(o) c(o$box[1], o$box[3])))
yl <- range(sapply(zs[as.integer(names(zc))], function(o) c(o$box[2], o$box[4])))

par(mar=rep(0,4))
plot(xl, yl, ty='n', axes=F, asp=1.3)
snippets::osmap(cache.dir="~")
for (i in as.integer(names(zc))) polygon(zs[[i]]$x, zs[[i]]$y, border="#00000040", col=heat.colors(16,alpha=0.5)[round(zc[as.character(i)]/max(zc)*15)+1])

zdi = do.dcall(function(long, lat)
    fastshp::inside(fastshp::read.shp("cb_2018_us_zcta510_500k.shp",
        format="poly"), long, lat),
    list(long=taxicab$dropoff_longitude, lat=taxicab$dropoff_latitude))
zdc = table(zdi)
zdc = zdc[zdc > 20]
par(mar=rep(0,4))
plot(xl, yl, ty='n', axes=F, asp=1.3)
snippets::osmap(cache.dir="~")
for (i in as.integer(names(zdc))) polygon(zs[[i]]$x, zs[[i]]$y, border="#00000040", col=heat.colors(16,alpha=0.5)[round(zdc[as.character(i)]/max(zdc)*15)+1])

## compute difference between pickups and dropoffs
u = unique(c(names(zdc), names(zc)))
up = zc[u];  up[is.na(up)] = 0 ## set to 0 where there is no match
ud = zdc[u]; ud[is.na(ud)] = 0
diff = ud - up

library(rcleaflet)
lmap(mean(xl), mean(yl), 10, tilepath="https://a.tile.openstreetmap.org/{z}/{x}/{y}.png")
col = snippets::col.bwr(diff, 0.5, lim=c(-max(abs(diff)),max(abs(diff))), fit=TRUE)
names(col) = names(diff)
for (i in as.integer(names(diff))) if (length(zs[[i]]$x)) lpolygon(zs[[i]]$x, zs[[i]]$y, border="#00000040", col=col[as.character(i)])

final()
