# useful code by Sakitin(GitHub@GunRain 酷安@芙洛洛 bilibili@安音咲汀)

# GitHub link: https://github.com/GunRain/SKT-Utils/blob/aaa/skt-utils.sh

alias del=rm # for rm check

run2null() {
  eval "$@" >/dev/null 2>&1
}

until_key() {
  while :; do
    local eventCode=`getevent -qlc 1 | awk '{if ($2=="EV_KEY" && $4=="DOWN") {print $3; exit}}'`
    case $eventCode in
      KEY_VOLUMEUP) printf up; return;;
      KEY_VOLUMEDOWN) printf down; return;;
      KEY_POWER) printf power; return;;
      KEY_F[1-9]|KEY_F1[0-9]|KEY_F2[0-4]) printf ${eventCode/KEY_F/f}; return;;
    esac
  done
}

until_key_any() {
  run2null until_key
}

until_key_up_down() {
  while :; do
    local key=`until_key`
    case $key in
      up|down) printf $key; return;;
    esac
  done
}

until_key_up_down_power() {
  while :; do
    local key=`until_key`
    case $key in
      up|down|power) printf $key; return;;
    esac
  done
}

until_key_up() {
  while :; do
    [ `until_key` = up ] && return
  done
}

until_key_down() {
  while :; do
    [ `until_key` = down ] && return
  done
}

until_key_power() {
  while :; do
    [ `until_key` = power ] && return
  done
}

goto_url() {
  [ ! -z "$1" ] || return
  run2null am start -a android.intent.action.VIEW -d \"$1\"
}

goto_app() {
  [ ! -z "$1" ] || return
  run2null am start \"$1\"
}

skt_abort() {
  run2null type abort && abort "! $@" || { echo -e "! $@"; exit 1; }
}

skt_print() {
  run2null type ui_print && ui_print "- $@" || echo -e "- $@"
}

newline() {
  local method=`run2null type ui_print && printf 'ui_print ""' || printf 'echo ""'`
  [ -z "$1" ] && { eval "$method"; return; }
  for _ in `seq 1 "$1"`; do eval "$method"; done
}

get_work_dir() {
  dirname "`readlink -f "$1"`"
}

pre_bin() {
  local bin="$1"
  [ -f "$bin" ] || return
  chmod a+x "$bin"
}

pre_bins() {
  for bin in "$@"; do
    pre_bin "$bin"
  done
}

run_bin() {
  local bin="$1"
  [ -f "$bin" ] || return
  pre_bin "$bin"
  shift
  eval "\"$bin\" $@"
}

nohup_bin() {
  local bin="$1"
  [ -f "$bin" ] || return
  pre_bin "$bin"
  shift
  nohup "$bin" $@ >/dev/null 2>&1 &
}

until_boot() {
  run2null resetprop -w sys.boot_completed 0  
  [ -z "$1" ] || sleep "$1"
}

until_unlock() {
  until_boot
  until [ -d /sdcard/Android ]; do sleep 1; done
  [ -z "$1" ] || sleep "$1"
}

is_ksu() {
  [ "$KSU" = true ]
}

is_ap() {
  [ "$APATCH" = true ]
}

not_magisk() {
  is_ksu || is_ap
}

magisk_run_completed() {
  not_magisk || { [ -f "$1/boot-completed.sh" ] && { . "$1/boot-completed.sh"; exit; }; }
}

set_dir_perm() {
  for dir in `find ${@} -type d`; do
    chmod 0755 "$dir"
  done
}

set_system_file() {
  chcon -R u:object_r:system_file:s0 ${@}
}

print_lines() {
  for line in "$@"; do
    echo "$line"
  done
}

get_target_bin() {
  [ -z "$MODPATH" ] && skt_abort 'Value "MODPATH" does not exist!'
  [ -z "$ARCH" ] && skt_abort 'Value "ARCH" does not exist!'

  local binName="$1"
  [ -z "$2" ] && local targetArch="$ARCH" || local targetArch="$2"
  mv -f "$MODPATH/bin/$binName/$targetArch.bin" "$MODPATH/$binName" || skt_abort "Arch \"$targetArch\" is not supported!"
  chmod a+x "$MODPATH/$binName"
}

get_target_bins() {
  for binName in "$@"; do
    get_target_bin "$binName"
  done
}

# 此函数较为特殊，用于批量安装模块功能，请完整阅读并理解此函数的代码后再使用此函数
run_install_list() {
  local func_head="$1"
  local func_num="$2"

  newline
  skt_print "通过按压音量上键切换安装内容，通过按压音量下键确定安装内容"
  newline

  for num in `seq 1 $func_num`; do
    eval "$(
      eval "$func_head$num" | {
        i=1
        while IFS= read line; do
          [ -z "$line" ] && continue
          case $i in
            1) echo "local target_func_head=\"$line\"";;
            2) echo "local opt_name=\"$line\"";;
            3) echo "local opt_num=\"$line\"";;
            4) echo "local cancel=\"$line\"";;
            *) echo "local opt_name_$((i-4))=\"$line\"";;
          esac
          let i++
        done
      }
    )"
    newline
    skt_print "抉择$num: $opt_name"
    newline
    [ $cancel = true ] && skt_print "内容0: 取消此抉择"
    for num in `seq 1 $opt_num`; do
      skt_print "内容$num: $(eval "echo -n \"\$opt_name_$num\"")"
    done
    newline
    [ $cancel = true ] && {
      local target_opt=0
      skt_print "当前选择内容: 取消此抉择"
    } || {
      local target_opt=1
      skt_print "当前选择内容: 内容1"
    }
    while :; do
      [ `until_key_up_down` = down ] && {
        newline
        [ $target_opt -eq 0 ] && {
          skt_print "已确定选择内容: 取消此抉择"
          true
        } || {
          skt_print "已确定选择内容: 内容$target_opt"
          eval "$target_func_head$target_opt"
        }
        newline
        break
      } || {
        let target_opt++
        [ $target_opt -gt $opt_num ] && {
          [ $cancel = true ] && {
            target_opt=0
            skt_print "当前选择内容: 取消此抉择"
            continue
          } || target_opt=1
        }
        skt_print "当前选择内容: 内容$target_opt"
      }
    done
  done
}

skt_install_init() {
  [ -z "$MODPATH" ] && skt_abort 'Value "MODPATH" does not exist!'

  # For Sakitin
  [ "$1" = official ] && {
    ui_print '- Official website: https://www.mod.latestfile.zip'
    shift
  }

  # Check files
  local hashListFile="$MODPATH/hashList.dat"
  [ -f "$hashListFile" ] || skt_abort 'File "hashList.dat" does not exist!'
  local hashList="`cat "$hashListFile" | zcat | base64 -d`"
  for file in $(find "$MODPATH/" -type f -not -path '*META-INF*' -not -name hashList.dat); do
    for target in "$@"; do [ "$target" = "$file" ] && continue; done
    [ "$(echo -n "$hashList" | grep -E " ${file#$MODPATH/}$" | awk '{print $1}')" = "$(sha1sum "$file" | awk '{print $1}')" ] || skt_abort "Failed to verify file \"${file#$MODPATH/}\"!"
  done
  del -f "$hashListFile"
}

skt_install_done() {
  [ -z "$MODPATH" ] && skt_abort 'Value "MODPATH" does not exist!'
  [ -z "$ARCH" ] && skt_abort 'Value "ARCH" does not exist!'

  # Clean bins
  [ -d "$MODPATH/bin" ] && del -rf "$MODPATH/bin"

  # For overlyfs
  [ -d "$MODPATH/system" ] && {
    set_dir_perm "$MODPATH/system"
    set_system_file "$MODPATH/system"
  }

  # Clean zygisk libs
  [ -d "$MODPATH/zygisk" ] && {
    case "$ARCH" in
      arm64) find "$MODPATH/zygisk" -name "riscv*.so" -o -name "x*.so" -delete;;
      arm) find "$MODPATH/zygisk" -name "riscv*.so" -o -name "x*.so" -o -name "*64*.so" -delete;;
      x64) find "$MODPATH/zygisk" -name "riscv*.so" -delete;;
      x86) find "$MODPATH/zygisk" -name "riscv*.so" -o -name "*64*.so" -delete;;
      riscv64) find "$MODPATH/zygisk" -name "arm*.so" -o -name "x*.so" -delete;;
    esac
  }

  # Clean useless files (just simply)
  for file in README LICENSE SECURITY; do
    for suffix in '' '.txt' '.md' '.mkd'; do 
      [ -f "$MODPATH/$file$suffix" ] && del -rf "$MODPATH/$file$suffix"
    done
  done
}