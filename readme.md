# Dynamic DNS Update Client (DUC) for Linux

This container it's fully Debian Friendly just change the custom options in bash_aliases file and run
Never miss time again configuring No-IP, easy like Docker.

```bash
git clone https://github.com/xslackx/ducnoip
cd ducnoip
sudo docker build . -t ducnoip:latest
sudo docker run -d --name ducnoip ducnoip:latest user_option
```

#### User options

        basic - login only using username and password
        setd - use specific daemon user and group
        dtime - set interval and timeout in daemon mode with custom group and user
        otime - same dtime without daemon user and group
        all - set all options include log info

## MUST be
Define the environment variables in bash_aliases file

This container has compatibility with © No-IP

https://www.noip.com/