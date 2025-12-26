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

#include <algorithm>
#include <sstream>
#include <string>
#include <string_view>

#include <cctype>

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

namespace s {
	/// @brief    不分大小写地判断两个字符串是否相同
	/// @param s1 第一个字符串
	/// @param s2 第二个字符串
	/// @return   两个字符串相同时返回true，否则为false
	NGA_INLINE static bool eq(strv s1, strv s2) {
		if (s1.size() != s2.size()) return false;
		else
			for (size_t i = 0; i < s1.size(); ++i)
				if (tolower(s1[i]) != tolower(s2[i])) return false;
		return true;
	}
	/// @brief    不分大小写且支持通配符*地判断前源字符串是否包含指定字符串
	/// @param s1 源字符串
	/// @param s2 指定字符串
	/// @return   源字符串包含指定字符串时返回true，否则为false
	NGA_INLINE static bool match(str s1, str s2) {
		transform(s1.begin(), s1.end(), s1.begin(), [](unsigned char c) { return tolower(c); });
		transform(s2.begin(), s2.end(), s2.begin(), [](unsigned char c) { return tolower(c); });
		if (s2 == "*") return true;
		else if (s2.find('*') == str::npos)
			if (s1.find(s2) == str::npos) return false;
			else return true;
		else {
			size_t		 pos = 0;
			stringstream ss(s2.data());
			str			 item, last_item;
			bool		 ok = false, check = false;
			while (getline(ss, item, '*'))
				if (item.empty()) continue;
				else if (pos = s1.find(item, pos);
						pos == str::npos || (!check && s2[0] != '*' && !s1.starts_with(item))) {
					ok = false;
					break;
				} else {
					ok = check = true;
					last_item  = item;
					pos++;
				}
			if (ok && (s2.back() == '*' || s1.ends_with(last_item))) return true;
			else return false;
		}
	}
	/// @brief   替换字符串头部
	/// @param s 源字符串
	/// @param f 要替换的内容
	/// @param t 要替换到的内容
	/// @return  替换后的源字符串
	NGA_INLINE static str replace_head(str s, strv f, strv t) {
		if (s.starts_with(f)) s.replace(0, f.length(), t);
		return s;
	}
	/// @brief   替换全部字符串
	/// @param s 源字符串
	/// @param f 要替换的内容
	/// @param t 要替换到的内容
	/// @return  替换后的源字符串
	NGA_INLINE static str replace_all(str s, strv f, strv t) {
		size_t p = 0;
		while ((p = s.find(f, p)) != str::npos) {
			s.replace(p, f.length(), t);
			p += t.length();
		}
		return s;
	}
	/// @brief   不分大小写地判断文件后缀
	/// @param s 文件名称
	/// @param t 后缀
	/// @return  后缀相同时返回true，否则为false
	NGA_INLINE static bool check_suffix(strv s, str t) {
		if (t = '.' + t; s.size() < t.size()) return false;
		else return eq(s.substr(s.size() - t.size()), t);
	}
} // namespace s
} // namespace NGA
