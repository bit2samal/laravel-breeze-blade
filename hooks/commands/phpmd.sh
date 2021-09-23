#!/bin/bash
# Lumen boilerplate githook script

# PHP Mess Detector
./vendor/bin/phpmd . text hooks/rules/phpmd_ruleset.xml --exclude vendor,_ide_helper.php,database,app/Console/Kernel.php,tests
RESULT=$?
[[ $RESULT -eq 0 ]] && echo "PHP Mess Detector check passed"

exit $RESULT