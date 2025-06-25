# LibSQL sqlite node application.

To use this copy the content of the
this directory to a place you prefer.

You need to install libsql to use the provided demo application.

On OSX you can use homebrew else
check you distribution for instructions on how to install.

The application requires that libSQL listen on port 8008. Either
change the code or setup libSQL to
use port 8008.

After you have installed libsql you
can initialize the libsql database with:

```
sqld -d /<path/formula1 --http-listen-addr=127.0.0.1:8008
```
The application requires that libSQL listen on port 8008. Either
change the code or start libSQL with

Stop libSQL (Normally Ctrl+C) and
then copy your f1.sqlite to
<Your path>/formula1formula1/dbs/default/data

Then you can start libSQL with
the formula1 database as:

```
sqld -d <path to libsql formula1 catalog> --http-listen-addr=127.0.0.1:8008
```
For the node part you need to install node and npm. Check your distribution for instructions.

Then copy the content of the subdirectory app/node/f1-qualification-viewer to your prefered directory.

Navigate to f1-qualifying-viewer catalog and initialize node and
required packages with

```
cd f1-qualification-viewer
npm init -y
npm install express axios
```

Now you should be able to run the
demo application using.

```
cd f1-qualification-viewer
node server.js
```
Use locahost:3000 to run the application in your browser.