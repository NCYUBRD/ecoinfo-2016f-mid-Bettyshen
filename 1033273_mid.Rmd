---
title: "1033273_mid_rmarkdown"
author: "沈芳伃"
date: "November 17, 2016"
output: html_document
---
#試題###

##一. 請隨機產生 10000 組正整數儲存成 vector 格式，並輸出成 random10k.csv (5%)

##二. 請使用 for 迴圈列出 15 個費布納西(Fibonacci)數列 (10%)

##三. 請將 sample_data.txt 輸入進 R 內，並完成以下計算 (55%)

(a) 將 yyyymmddhh 轉成 POSIXct 時間戳記格式， 並新增為一個欄(variable)，命名為 timestamp。並將此 sample data 輸出為 sample_data_parsed.csv (以逗號分隔，具有欄位名稱)

(b) 請計算 2014 年至 2015 年這個測站的每月平均氣溫、每月平均濕度、每月累積降水，並用表格呈現 
(c) 請計算 2014 年和 2015 年最冷月分別是在哪個月份？(提示：先計算月均溫)
(d) 在 2015 年最冷的那個月份中，該月中每日的最低溫平均是幾度C？

(e) 請計算 2014 年和 2015 年中，最熱的月分別是在哪個月份？

(f) 請計算 2014 年最熱的月份中，該月的每日最高溫平均為幾度C?

(g) 請算出 2014 至 2015 年中，最濕月份的平均溫度

(h) 請計算每個月的月溫差(每月最高溫減去每月最高溫，取兩年平均)，平均月溫差最大的是哪個月？

(i) 請計算這兩年的年溫差平均(每年最高溫減去最低溫)

(j) 溫量指數(warmth index)是 Kira (1945) 提出的一個生態氣候指標，其計算方式為:
(k) 請使用 climatol package 繪製 2014 至 2015 的生態氣候圖(Ecological climate diagrams)。 提示：你需要計算出每個月的累積降水平均、每日最高溫平均、每日最低溫平均、每月絕對最低溫。 可參考繪製生態氣候圖

##四. 請計算 Table 2 中的下列各子題 (30%)

(a) 請計算各島環境因子(total_cover, C, EC, ..., etc.) 的平均、 第一四分位數、中位數、第三四分位數、最大值及最小值以及標準差，並整理成如下表格：
(b) 請分別列出 C, EC, K, Na, N 最高的五個樣區(plotid)

#解答一
產生10000組隨機正整數,使用sample.int(n, size = n, replace = FALSE, prob = NULL)，正整數定義為：大於零且間隔等於一的整數
```{r}

random10k<-sample.int(10000)
print(random10k)
#檔案輸出write.csv()
write.csv(random10k,file = '~/Desktop/生態資訊學/生態資訊學期中考/random10k.csv')


```
#解答二
使用費部納西數列：因此先設定15個數字的數列，再指定第一個數值為1、第二個數值為2。再用for迴圈寫出後面一個數值是由前面兩個數值相加而成
```{r}
sequence <- 15
fib <- numeric(sequence)
#指定第一個數值為"1"、第二個數值為"2"
fib[1] <-1
fib[2] <-2
#用for迴圈寫出前一個數值是由前兩個數值相加,因為前兩個數值已經設定好，我們從第三個數值開始設定即可
for (i in 3:sequence) {fib[i] <- fib[i-2]+fib[i-1]
  
}
print(fib)
```
#解答三
(a)先將檔案匯入進來，打開檔案查看檔案格式與每列代表的意義：
yyyymmddhh: 西元四位數年
PS01: 測站氣壓(hPa)
TX01: 溫度(ºC)
RH01: 相對濕度(%)
WD01: 平均風風速(m/s)
WD02: 平均風風向(360 degree)
PP01: 降水量(mm)
SS01: 日照時數(hr)
##從原始資料可以發現有些日期的資料呈現-9996、-9997、-9999，有可能是記錄裝置出現問題，因此我們將這些資料設定為NA，這樣在未來統計資料時就不會影響原始資料了,另外我們將 yyyymmddhh 轉成 POSIXct 時間戳記格式
```{r}
#輸入必要的library,設定工作目錄,將'sample_data.txt'匯入r中

library(data.table)
setwd('~/Desktop/生態資訊學/生態資訊學期中考/')

#將資料呈現-9996、-9997、-9999數值轉為NA
sample_data <- read.table('~/Desktop/生態資訊學/生態資訊學期中考/sample_data.txt',header = TRUE,na.strings = c('-9996','-9997','-9999'))

#先確定他是否為data.frame格式，再將 yyyymmddhh 轉成 POSIXct 時間戳記格式,再增設一個欄(variable),命名為" timestamp"
class(sample_data)

#格式為data.frame沒錯
#先指定原始資料第一欄"$"，因為一開始時間軸都是從第一小時開始計算，我們想要固定格式從"0"小時開始，所以我們把原始時間都"-1"。用strptime置換時間格式成"2014-01-01 02:00:00"的樣式


timestamp <- as.POSIXct(strptime(sample_data$yyyymmddhh-1,'%Y%m%d%H'))
#定義'日'時間格式
day <- format.Date(timestamp,'%Y%m%d')
#定義'日'時間格式
month <- format.Date(timestamp,'%Y%m')
#定義'年'時間格式
year <- format.Date(timestamp,'%Y')
#將新增欄位用"cbind"合併
sample_data_allcol<- cbind(sample_data,timestamp, day , month, year)



#輸出為 sample_data_parsed.csv
write.csv(sample_data_allcol,file='~/Desktop/生態資訊學/生態資訊學期中考/sample_data_parsed',sep = ",")

```
#(a~b)
我們要計算“每月平均氣溫、每月平均濕度、每月累積降水“
平均使用:mean、累積使用：sum
```{r}
#製作出mean公式mean_omit_na
mean_omit_na <-function(x){
  x<-as.numeric(x)
  return(mean(x, na.rm = T))
}

#平均每月均溫
mean_MonTem<-aggregate(sample_data_allcol$TX01, by= list (sample_data_allcol$month) ,FUN= mean_omit_na)

mean_MonTem
#平均每月濕度
mean_MonWet<-aggregate(sample_data_allcol$RH01, by= list
(sample_data_allcol$month), FUN= mean_omit_na)
mean_MonWet
#製作出sum公式sum_omit_na
sum_omit_na <-function(x){
  x<-as.numeric(x)
  return(sum(x, na.rm = T))
}
#計算每月累積降水
sum_MonPre<- aggregate(sample_data_allcol$PP01, by=list
(sample_data_allcol$month),FUN= sum_omit_na)
sum_MonPre
#將以上數值做成data.frame格式，用cbind合併
Month_collumn<- cbind.data.frame(mean_MonTem,mean_MonWet,sum_MonPre)
Month_collumn<-data.frame(Month_collumn, row.names = TRUE)
Month_collumn_trans<-t(Month_collumn)
#清除不必要的欄位
Month_collumn_trans<-Month_collumn[-c(2,4),]
Month_collumn_trans<-data.frame(Month_collumn_trans)
```

#(c)計算2014和2015年最冷月分別在哪個月份？
```{r}
#做出最冷min的方程式
coldest<-function(x){
  x<-as.numeric(x)
  return(min(x, na.rm = TRUE))
}

Min_Tep<- aggregate(TX01~month, data = sample_data_allcol,FUN= coldest)
```


#(d)2015最冷月份"2"月，該月中每日最低溫平均是幾度C?
```{r}
Coldest_Feb <-aggregate(sample_data_allcol$TX01~"2015-2", data = Min_Tep,FUN=coldest)

```
#(e)請計算2014年和2015年，最熱的月份分別為哪兩個月？
```{r}
#做出最熱max的方程式
hottest<-function(x){
  x<-as.numeric(x)
  return(max(x, na.rm = TRUE))
}
Max_Tep<- aggregate(TX01~month, data = sample_data_allcol, FUN=
hottest)
#2014年9月最熱;2015年6月最熱
```
#(f)請計算2014年最熱月份中，該月的每日最高溫平均為幾度C?
```{r}

```
#(g)請計算出2014~2015年中，最溼月份的平均溫度
```{r}
#先看哪個月份是最濕的,設定最濕月份的公式
wettest<-function(x){
  x<-as.numeric(x)
  return(max(x, na.rm = TRUE))
}
#代入公式，看哪個月份最潮濕
Wettest_month <- aggregate(PP01~month, data=sample_data_allcol, FUN= wettest)
#2014年7月最潮濕
#2014年7月平均溫度
mean_201407_Tep <- aggregate(sample_data_allcol$TX01,by=list(sample_data_allcol$month=='201407'),FUN=mean_omit_na)
#2014年7月平均溫度為：29.40343
```
#(h)請計算每個月的月溫差，平均月溫差最大的是哪個月？
```{r}
```

#試題四
(a) 請計算各島環境因子(total_cover, C, EC, ..., etc.) 的平均、 第一四分位數、中位數、第三四分位數、最大值及最小值以及標準差，並整理成如下表格
```{r}
#將澎湖南方四島的資料輸入進來
sample_data_Penghu <- read.csv('~/Desktop/生態資訊學/生態資訊學期中考/penghu_env.csv',header = TRUE)
#各項平均
Penghu_mean <- aggregate(sample_data_Penghu$total_cover, by=list( sample_data_Penghu$total_cover), FUN= mean_omit_na)
```