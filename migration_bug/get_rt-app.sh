git clone https://github.com/scheduler-tools/rt-app.git
cd rt-app
git am ../0001-Allow-to-synchronize-all-the-tasks-at-start.patch
./autogen.sh
./configure --with-deadline --with-json
make

