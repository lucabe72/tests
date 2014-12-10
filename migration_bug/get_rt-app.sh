git clone https://github.com/scheduler-tools/rt-app.git
cd rt-app
./autogen.sh
./configure --with-deadline --with-json
make

