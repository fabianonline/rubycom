Rubycom
=======

Rubycom is a webcomic downloader and viewer application, just like dailystrips.
It's written in RubyOnRails and, um... it's great.

It started as a personal project, but perhaps someone wants to use (or even contribute) to it...


Installation
------------

1. You need a normal RoR enabled webserver.
2. Clone rubycom.
3. Copy `config/database.yml.example` to `config/database.yml` and modify it to your likings.
4. Do the same with `config/config.yml.example`.
5. Run `rake db:migrate`.
6. Make sure the webserver has the right to write into `public/comics`.
7. It is also advisable to give the webserver permission to modify `config/comics.yml`.
8. Call rubycom in your webbrowser.
9. Have fun?


Automatic Updates
-----------------

### How do they work?

Rubycom fetches the file config/comics.yml from this repository and uses it to update or add new
comics to your local comic list - if you wish.

### Can I extend this list?

Of course. Fork this project, add new comics to your list (or repair existing comics) and then run
`rake comics:dump`. This will regenerate `config/comics.yml` with your local comics. Commit, push and
send me a pull request. I'll be happy to merge it.

### Updates via github
If you use the "Comic-Definitionen updaten" link, Rubycom will automatically pull the comic definitions from
the "official" repository (fabianonline/rubycom/master), and you can select which of these definitions
you want to use.

### Updates via cron
rubycom can fetch all comics from their individual websites via cron. The command you need to enter in your crontab is
'path/to/rubycom/script/runner "Comic.update_all" -e production'. You can enter your email address in config/config.yml, so every time
an error occurs (i.e. the source of a comic is not accessible), rubycom will send you a mail.