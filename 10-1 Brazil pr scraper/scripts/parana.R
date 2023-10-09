library(rvest)
library(tidyverse)

# TO DO: Get all the urls from page 1 into a list
# then for each article, organize the info into a datafrom with the title, 
# date, and the text as separate columns

parana<-tibble()

get_date<-function(article_link) {
  article_page=read_html(article_link)
  article_date=article_page%>%html_nodes(".documentPublished .value")%>%html_text()
  return=article_date
}

get_text<-function(article_link) {
  article_page=read_html(article_link)
  article_text=article_page%>%html_nodes("#parent-fieldname-text p")%>%html_text() %>%
    paste(collapse=" ")
  return=article_text
}

for (i in seq(from=0,to=360,by=20)) {
   link=paste0("https://www.gov.br/prf/pt-br/noticias/estaduais/parana?b_start:int=",i)
   page=read_html(link)
   name=page%>%html_nodes(".titulo a")%>%html_text
   article_link=page%>%html_nodes(".titulo a")%>%html_attr("href")
   date=sapply(article_link,FUN=get_date)
   text=sapply(article_link,FUN=get_text)
   parana=rbind(parana,tibble(name,date,text))
   print(paste("Page:",i))
}

write_csv(parana,"parana_pr.csv")
