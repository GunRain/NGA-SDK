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
#include <string>
#include <string_view>
#include <vector>

#include <fcntl.h>
#include <poll.h>
#include <unistd.h>

#include <sys/stat.h>
#include <sys/types.h>

#include <linux/input.h>

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

namespace key {
	NGA_INLINE vec<str> getInputs(int TYPE) {
		vec<str> targets;
		for (fs::directory_entry const& entry : fs::directory_iterator("/dev/input"))
			if (str const input = entry.path().string(); entry.is_character_file())
				if (int fd = open(input.data(), O_RDONLY); fd >= 0) {
					unsigned char evBits[(KEY_MAX + 7) / 8] = { 0 };
					ioctl(fd, EVIOCGBIT(EV_KEY, sizeof(evBits)), evBits);
					if (evBits[TYPE / 8] & (1 << (TYPE % 8))) targets.push_back(input);
					close(fd);
				}
		return targets;
	}
	class listener {
	   public:
		NGA_INLINE listener(listener const&)			= delete;
		NGA_INLINE listener& operator=(listener const&) = delete;
		NGA_INLINE ~listener(void) { free(); }
		NGA_INLINE static unique_ptr<listener> create(int TYPE) {
			return unique_ptr<listener>(new listener(TYPE));
		}
		NGA_INLINE bool listen(void) {
			if (_fds.empty()) return false;
			for (;;) {
				if (poll(_fds.data(), _fds.size(), -1) < 0) return false;
				for (pollfd& pfd : _fds)
					if (pfd.revents & POLLIN) {
						struct input_event event;
						ssize_t			   bytesRead = read(pfd.fd, &event, sizeof(event));
						if (bytesRead > 0 && event.type == EV_KEY && event.code == _type
								&& event.value == 1)
							return true;
					}
			}
		}
		NGA_INLINE void free(void) {
			if (_fds.empty()) return;
			for (pollfd& pfd : _fds) close(pfd.fd);
			_fds.clear();
		}

	   private:
		NGA_INLINE listener(int TYPE): _type(TYPE) {
			for (str const& eventPath : getInputs(TYPE))
				if (int fd = open(eventPath.data(), O_RDONLY); fd >= 0) _fds.push_back({ fd, POLLIN, 0 });
		}
		vec<struct pollfd> _fds;
		int				   _type;
	};
} // namespace key
} // namespace NGA
