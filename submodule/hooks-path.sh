git submodule foreach -q \
'path=$(echo $path | cut -d/ -f2) && \
if [ "$path" != "db-fixture-rest-api" ]; \
then git config core.hooksPath ../.husky && \
echo "$path hooksPath changed"; \
fi;' || :