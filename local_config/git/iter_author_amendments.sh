#!/bin/bash -l

#source /usr/share/bashdb/bashdb-trace

echo "This script assumes the commit process was corrupted and caused one or more\
nonconformities that, if exist in a repo, exist for every commit since the corruption\
until present."

# current nonconfirmity: email not linked to github account, which affects, \
#   among other things, the git calendar.
#preferred_email=$1
preferred_email="blinddiver@gmail.com"
git_user_name="sethc23"

# get all of github and local repos
#current_github_repos=`git hub repos $git_user_name | sed -r 's/(^[^ ]*)\s*(.*)$/\1/g'`

current_github_repos="BD_Scripts logrotate_config_tester Lua NYC_GIS PastebinPython py_classes seamless_yelp_scraping system_config"
most_local_repos=`locate .git/config | env grep --color=never -E "^$HOME/(.*)/config$"`


# --
#github_cnt=`echo "$current_github_repos" | wc -l`
#local_cnt=`echo "$most_local_repos" | wc -l`
# optimize iteration arrangement
#if [[ github_cnt -gt local_cnt ]]; then
#    _outer=$most_local_repos
#    _inner=$current_github_repos
#else
#    _outer=$current_github_repos
#    _inner=$most_local_repos
#fi
# --


# for all github repos:
#   identify corresponding local repo and change to that directory;
#   traverse backward through commits until finding a conforming commit ("start_pt");
#   move head to start_pt and amending all commits while traversing back to present;
#   force push update to github;
#   confirm push accepted, active on master branch, nothing to commit, and working directory clean;
#   remove local_repo from list;

_Dbg_debugger

for g in $current_github_repos; do
    chk="0"
    for l in $most_local_repos; do
        chk=`cat $l | grep $g | sed -r 's/\s//g' | grep ^url= | wc -l`
        if [[ $chk -eq 1 ]]; then
            local_path=`echo $l | sed 's/\/\.git\/config//g'`
            break
        fi
    done
    if [[ $chk -lt 1 ]]; then
        echo "NO LOCAL MATCH FOR: "$g
        _Dbg_debugger
        exit 1
    else
        cd $local_path
        last_commit=`git log -1 --format=%h HEAD | more`

        #add check for when first commit is OK

        while true; do
            next_oldest_email_commit=`git log -1 --format=%ce_%h HEAD^1 | head -n 1`
            len_a=`echo $next_oldest_email_commit | xargs -I '{}' python -c "print len('"{}"')"`
            next_oldest_w_repl=`echo $next_oldest_email_commit | sed -r "s/$preferred_email//g"`
            len_b=`echo $next_oldest_w_repl | xargs -I '{}' python -c "print len('"{}"')"`

            if [[ $check=="stop" ]]; then
                break
            else
                last_commit=$check
            fi
        done

        echo "LAST_COMMIT="$last_commit
        _Dbg_debugger

        for _err in `git show -s --format=%ce $last_commit..HEAD | more`; do
            echo $_err
        done

        echo "DONE"

        _Dbg_debugger
    fi

done

# for whatever repos
#   change directory to repo
#   F1: from provided date to present, fix corruption

# F1 (earliest_non_err_datetime='as epoch',err_check='email',err_fix)
#