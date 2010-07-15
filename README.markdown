RoboLogger
==========
I got tired of CTRL+F'ing my way through nightly robocopy logs. If you're using robocopy for regular data replication, RoboLogger might be of some help.

Step 1
------
Output the logs to text files using the /LOG+\\host\networkshare switch in your robocopy script. This location must be accessible from the web server hosting this application.

Step 2
------
Install ruby 1.9.2 and rubygems on your Linux web server.

Step 3
------
Install the required gems:
<code>gem install sinatra dm-core dm-timestamps dm-migrations mail dm-sqlite-adapter</code>

Step 4
------
Copy the config.example.yml to config.yml, and edit it with your information

config.yml
<pre>
---
email:
  to:     recipient@yourdomain.com        #Who the email report should go to
  from:   sender@yourdomain.com           #Who the email is coming from
  server: mail.yourdomain.com             #FQDN or IP of your mail server
  host:   robologger.yourdomain.com       #FQDN or IP of the web server hosting this applicaiton

parsing:
  path_to_logs:   /shares/robocopy/logs   #path where the robocopy logs are stored with .txt extensions
</pre>

Step 5
------
Parse your files.
<code>ruby parse.rb</code>

Start your webserver
<code>ruby server.rb</code>

Send your email notification
<code>ruby notify.rb</code>

I would recommend running the 'parse' and 'nofity' script using cron or one of the many ruby scheduling libraries (DelayedJob, Clockwork, etc.)

You can use passenger/Apache to serve the web application. http://www.modrails.com

License
=======
Copyright (c) 2010 Daniel Westendorf

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
