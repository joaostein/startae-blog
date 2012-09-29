xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title "Blog Startaê"
  xml.subtitle "Pensamentos, novidades, atualizações de produtos, links e tudo o que está acontecendo no Startaê"
  xml.id "http://blog.startae.com.br/"
  xml.link "href" => "http://blog.startae.com.br/"
  xml.link "href" => "http://blog.startae.com.br/feed.xml", "rel" => "self"
  xml.updated blog.articles.first.date.to_time.iso8601
  xml.author { xml.name "Startaê" }

  blog.articles[0..5].each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => article.url
      xml.id article.url
      xml.published article.date.to_time.iso8601
      xml.updated article.date.to_time.iso8601
      xml.author { xml.name data.page.author }
      xml.summary article.summary, "type" => "html"
      xml.content article.body, "type" => "html"
    end
  end
end