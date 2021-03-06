set -x
set -e
#export DYLD_LIBRARY_PATH=`pwd`/anaconda/lib:`pwd`/anaconda/lib/cyclus:$DYLD_LIBRARY_PATH
#export LD_LIBRARY_PATH=`pwd`/anaconda/lib:`pwd`/anaconda/lib/cyclus
    # check that unit tests ran
PATH=`pwd`/anaconda/bin:$PATH
anaconda/bin/cyclus --install-path
anaconda/bin/cyclus --nuc-data
anaconda/bin/cyclus --version

    if  [[ "${_NMI_TASKNAME}" == CYCAMORE* ]]
    then
        anaconda/bin/cycamore_unit_tests --gtest_filter=`echo ${_NMI_TASKNAME} | sed -e 's/__/\//g' | sed -e 's/CYCAMORE.//g'`
    elif [[ "${_NMI_TASKNAME}" == CYCLUS* ]]
    then
        anaconda/bin/cyclus_unit_tests --gtest_filter=`echo ${_NMI_TASKNAME} | sed -e 's/__/\//g' | sed -e 's/CYCLUS.//g'`
    elif [[  "${_NMI_TASKNAME}" == R*  ]]
    then
    
        # run regression tests
        export PYTHONPATH=$PYTHONPATH:anaconda:anaconda/lib/python2.7/site-packages
        export LD_LIBRARY_PATH=anaconda/lib/:$LD_LIBRARY_PATH
        export PATH=anaconda/bin/:$PATH
        anaconda/bin/nosetests -vsw cycltest
        anaconda/bin/nosetests -vsw cycatest

    else
    anaconda/bin/cyclus_unit_tests --gtest_repeat=1
    anaconda/bin/cycamore_unit_tests --gtest_repeat=1
    anaconda/bin/nosetests -vsw cycatest
    # check that unit tests ran
    if [ $? -ne 0 ]
    then
        exit $?
    fi
fi

exit $?
