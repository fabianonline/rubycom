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

