fs = require 'fs'
mkdirp = require 'mkdirp'
mustache = require 'mustache'

Entities = require("html-entities").XmlEntities
entities = new Entities()

mode = 0o0775

Writer = ->
  return this

Writer.prototype.write_authors = (authors) ->
  mkdirp.sync './contents/authors', mode
  fs.writeFileSync("./contents/authors/#{author.shortname}.json", JSON.stringify(author)) for author in authors when author.name isnt ' '

Writer.prototype.write_content = (obj) ->
  template = fs.readFileSync('./lib/templates/article.mustache').toString()
  for post in obj.posts
    content = post.content
    content = content.replace /^\s+|\s+$/g, ""
    if content isnt ""
        post.author = obj.globals.authors[0].shortname
        post_folder = "./contents/articles/#{post.filename}"
        mkdirp.sync(post_folder, mode)
        post.tags = post.tags.join(",")
        postNew = mustache.render template, post
        
        postNew = entities.decode postNew
        
        fs.writeFileSync "#{post_folder}/index.md", postNew

module.exports = new Writer()
