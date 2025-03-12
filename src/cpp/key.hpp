//================================================================================================================
// Copyright (c) 2023-present Anne Sakitin (Tianwan Ayana).                                                      =
//                                                                                                               =
// Part of the NGA project.                                                                                      =
// Licensed under the F2DLPR License.                                                                            =
//                                                                                                               =
// YOU MAY NOT USE THIS FILE EXCEPT IN COMPLIANCE WITH THE LICENSE.                                              =
// Provided "AS IS", WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,                                               =
// unless required by applicable law or agreed to in writing.                                                    =
//                                                                                                               =
// For details about the NGA project, visit: http://app.niggergo.work.                                           =
// For details about the F2DLPR License terms and conditions, visit: http://license.fileto.download.             =
//================================================================================================================

#pragma once

#include <fcntl.h>
#include <filesystem>
#include <linux/input.h>
#include <poll.h>
#include <string>
#include <string_view>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <vector>

#ifndef NGA_INLINE
#if defined(__GNUC__)
#define NGA_INLINE __attribute__((always_inline)) inline
#elif defined(_MSC_VER)
#define NGA_INLINE __forceinline
#else
#define NGA_INLINE inline
#endif
#endif

namespace NGA {
  using namespace std;
  using str = string;
  using strv = string_view;
  template <typename T>
  using vec = vector<T>;
  namespace fs = filesystem;

  namespace key {
    vec<str> getInputs(int TYPE) {
      vec<str> targets;
      for (const fs::directory_entry& entry : fs::directory_iterator("/dev/input"))
        if (const str input = entry.path().string(); entry.is_character_file())
          if (int fd = open(input.data(), O_RDONLY); fd >= 0) {
            unsigned char evBits[(KEY_MAX + 7) / 8] = {0};
            ioctl(fd, EVIOCGBIT(EV_KEY, sizeof(evBits)), evBits);
            if (evBits[TYPE / 8] & (1 << (TYPE % 8)))
              targets.push_back(input);
            close(fd);
          }
      return targets;
    }
    class listener {
  public:
      static listener& getInstance() {
        static listener instance;
        return instance;
      }
      listener(const listener&) = delete;
      listener& operator=(const listener&) = delete;
      bool listen(int TYPE) {
        if (fds.empty())
          for (const str& eventPath : getInputs(TYPE))
            if (int fd = open(eventPath.data(), O_RDONLY); fd >= 0)
              fds.push_back({fd, POLLIN, 0});
        if (fds.empty())
          return false;
        while (1) {
          if (poll(fds.data(), fds.size(), -1) < 0)
            return false;
          for (pollfd& pfd : fds)
            if (pfd.revents & POLLIN) {
              struct input_event event;
              ssize_t bytesRead = read(pfd.fd, &event, sizeof(event));
              if (bytesRead > 0 && event.type == EV_KEY && event.code == TYPE && event.value == 1)
                return true;
            }
        }
      }

  private:
      listener() = default;
      ~listener() {
        for (pollfd& pfd : fds)
          close(pfd.fd);
      }
      vec<struct pollfd> fds;
    };
  } // namespace key
} // namespace NGA
