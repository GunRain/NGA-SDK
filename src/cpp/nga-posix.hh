//====================================================================================================
// Copyright (C) 2016-present ShIroRRen <http://shiror.ren>.                                         =
//                                                                                                   =
// Part of the NGA project.                                                                          =
// Licensed under the F2DLPR License.                                                                =
//                                                                                                   =
// YOU MAY NOT USE THIS FILE EXCEPT IN COMPLIANCE WITH THE LICENSE.                                  =
// Provided "AS IS", WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,                                   =
// unless required by applicable law or agreed to in writing.                                        =
//                                                                                                   =
// For the NGA project, visit: <http://app.niggergo.work>.                                           =
// For the F2DLPR License terms and conditions, visit: <http://license.fileto.download>.             =
//====================================================================================================

#pragma once

#include <filesystem>
#include <sstream>
#include <string>
#include <string_view>
#include <system_error>
#include <vector>

#include <cstring>
#include <ctime>

#include <dirent.h>
#include <fcntl.h>
#include <unistd.h>

#include <sys/stat.h>

#ifndef NGA_INLINE
#ifdef __GNUC__
#define NGA_INLINE __attribute__((always_inline)) inline
#elif defined(_MSC_VER)
#define NGA_INLINE __forceinline
#else
#define NGA_INLINE inline
#endif
#endif

namespace NGA {
using namespace std;
using str  = string;
using strv = string_view;
template<typename T>
using vec	 = vector<T>;
namespace fs = filesystem;

/// @brief  执行指令
/// @param  指令
/// @return stdout
str cmd(strv c) {
	if (FILE* fp = popen(c.data(), "r")) {
		str ret;
		int ch;
		while ((ch = fgetc(fp)) != EOF) ret.push_back(ch);
		return pclose(fp), ret;
	}
	return "";
}

namespace f {
	/// @brief  判断路径是否存在
	/// @param  路径
	/// @return 路径存在时返回true，否则为false
	NGA_INLINE static bool ok(strv p) { return !access(p.data(), F_OK); }
	/// @brief  判断路径是否为目录
	/// @param  路径
	/// @return 路径为目录时返回true，否则为false
	NGA_INLINE static bool dok(strv p) {
		struct stat stat_buf;
		return !stat(p.data(), &stat_buf) && S_ISDIR(stat_buf.st_mode);
	}
	/// @brief  判断路径是否为文件
	/// @param  路径
	/// @return 路径为文件时返回true，否则为false
	NGA_INLINE static bool fok(strv p) { return !dok(p); }
	/// @brief  判断路径是否为空目录
	/// @param  路径
	/// @return 路径为空目录时返回true，否则为false
	NGA_INLINE static bool dmt(strv p) {
		if (DIR* dir = opendir(p.data())) {
			while (const struct dirent* entry = readdir(dir))
				if (strcmp(entry->d_name, ".") && strcmp(entry->d_name, ".."))
					return closedir(dir), false;
			return closedir(dir), true;
		}
		return false;
	}
	/// @brief  判断路径是否为空文件
	/// @param  路径
	/// @return 路径为空文件时返回true，否则为false
	NGA_INLINE static bool fmt(strv p) {
		struct stat st;
		return !stat(p.data(), &st) && st.st_size == 0;
	}
	/// @brief  获取文件内容为字符串
	/// @param  路径
	/// @return 文件内容
	NGA_INLINE static str read(strv p) {
		if (FILE* f = fopen(p.data(), "r")) {
			str ret;
			int c;
			while ((c = fgetc(f)) != EOF) ret.push_back(c);
			return fclose(f), ret;
		}
		return "";
	}
	/// @brief   移动文件
	/// @param s 源路径
	/// @param d 指定路径
	/// @return  移动成功时返回true，否则为false
	NGA_INLINE static bool mv(strv s, strv d) {
		error_code ec;
		if (str const dp = fs::path(d).parent_path().string(); !ok(dp))
			if (fs::create_directories(dp, ec); ec) return false;
		struct stat si;
		if (stat(s.data(), &si)) return false;
		struct timespec dt[2] = {
			{ si.st_atime, 0 },
			{ si.st_mtime, 0 }
		};
		if (rename(s.data(), d.data()))
			if (fs::copy(s, d, ec); !ec)
				if (utimensat(AT_FDCWD, d.data(), dt, 0); remove(s.data())) return false;
				else return true;
			else return false;
		else utimensat(AT_FDCWD, d.data(), dt, 0);
		return true;
	}
	/// @brief  获取文件的修改时间
	/// @param  路径
	/// @return %Y-%m-%d格式的修改时间
	NGA_INLINE static str time(strv p) {
		struct stat fileInfo;
		if (stat(p.data(), &fileInfo)) return "";
		time_t		  time	   = fileInfo.st_mtime;
		tm*			  timeInfo = localtime(&time);
		ostringstream oss;
		return oss << put_time(timeInfo, "%Y-%m-%d"), oss.str();
	}
	/// @brief  支持通配符*地匹配路径(不会匹配.开头路径)
	/// @param  路径
	/// @return 匹配到的存在的路径
	NGA_INLINE static vector<string> paths(strv p) {
		if (p.find('*') == str::npos)
			if (ok(p)) return { p.data() };
			else return {};
		else {
			vector<string> rets;
			fs::path	   tmp_path = "/";
			stringstream   ss(p.data());
			str			   item;
			while (getline(ss, item, '/'))
				if (item.empty()) continue;
				else if (item.find('*') == str::npos)
					if (rets.empty()) tmp_path /= item;
					else {
						vector<string> tmp_paths;
						for (str const& path : rets)
							if (str const target = (fs::path(path) / item).string(); ok(target))
								tmp_paths.push_back(target);
						if (tmp_paths.empty()) return {};
						rets = tmp_paths;
					}
				else {
					vector<string> tmp_paths;
					for (str const& dir_path :
							rets.empty() ? (vector<string>){ tmp_path.string() } : rets)
						if (DIR* dir = opendir(dir_path.data())) {
							while (const struct dirent* entry = readdir(dir))
								if (str const name = entry->d_name; !name.starts_with('.'))
									if (item == "*")
										tmp_paths.push_back((fs::path(dir_path) / name).string());
									else {
										size_t		 pos = 0;
										stringstream ss(item);
										str			 sub, real_sub;
										bool		 ok = false, check = false;
										while (getline(ss, sub, '*'))
											if (sub.empty()) continue;
											else if (pos = name.find(sub, pos);
													pos == str::npos
													|| (!check && item[0] != '*'
															&& !name.starts_with(sub))) {
												ok = false;
												break;
											} else {
												ok = check = true;
												real_sub   = sub;
												pos++;
											}
										if (ok && (item.back() == '*' || name.ends_with(real_sub)))
											tmp_paths.push_back((fs::path(dir_path) / name).string());
									}
								else continue;
							closedir(dir);
						}
					if (tmp_paths.empty()) return {};
					rets = tmp_paths;
				}
			return rets;
		}
	}
} // namespace f
} // namespace NGA
