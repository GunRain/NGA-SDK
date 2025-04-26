//====================================================================================================
// Copyright (C) 2023-present Anne Sakitin (Tianwan Ayana).                                          =
//                                                                                                   =
// Part of the NGA project.                                                                          =
// Licensed under the F2DLPR License.                                                                =
//                                                                                                   =
// YOU MAY NOT USE THIS FILE EXCEPT IN COMPLIANCE WITH THE LICENSE.                                  =
// Provided "AS IS", WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,                                   =
// unless required by applicable law or agreed to in writing.                                        =
//                                                                                                   =
// For details about the NGA project, visit: http://app.niggergo.work.                               =
// For details about the F2DLPR License terms and conditions, visit: http://license.fileto.download. =
//====================================================================================================

package nga

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"time"
	_ "time/tzdata"
)

type LogLevel uint8

const (
	LOG_NONE LogLevel = iota
	LOG_ERROR
	LOG_WARN
	LOG_INFO
	LOG_DEBUG
	LOG_VERBOSE
)

var logLv2Str = map[LogLevel]string{
	LOG_NONE:    "?",
	LOG_ERROR:   "E",
	LOG_WARN:    "W",
	LOG_INFO:    "I",
	LOG_DEBUG:   "D",
	LOG_VERBOSE: "V",
}

type Logger struct {
	file         *os.File
	LogLevel     LogLevel
	LastLogLevel LogLevel
	queue        chan string
	wg           sync.WaitGroup
	TimeLoc      *time.Location
	TimeFmt      string
}

func NewLogger(path string, mode int, lv LogLevel) (*Logger, error) {
	if err := os.MkdirAll(filepath.Dir(path), 0777); err != nil {
		return nil, err
	}
	file, err := os.OpenFile(path, os.O_CREATE|os.O_WRONLY|mode, 0666)
	if err != nil {
		return nil, err
	}
	logger := &Logger{
		file:         file,
		LogLevel:     lv,
		queue:        make(chan string, 114),
		TimeLoc:      time.Local,
		TimeFmt:      "01-02 15:04:05.000",
		LastLogLevel: LOG_NONE,
	}
	if PathExist("/system/bin/getprop") {
		out, err := exec.Command("/system/bin/getprop", "persist.sys.timezone").Output()
		if err == nil {
			loc, err := time.LoadLocation(strings.TrimSpace(string(out)))
			if err == nil {
				logger.TimeLoc = loc
			}
		}
	}
	go func() {
		for msg := range logger.queue {
			_, _ = logger.file.WriteString(msg + "\n")
			logger.wg.Done()
		}
	}()
	return logger, nil
}

func (_logger *Logger) log(lv LogLevel, msg string, o ...any) {
	if lv <= _logger.LogLevel {
		_logger.wg.Add(1)
		_logger.LastLogLevel = lv
		_logger.queue <- time.Now().In(_logger.TimeLoc).Format(_logger.TimeFmt) + " [" + logLv2Str[lv] + "] " + fmt.Sprintf(msg, o...)
	}
}

func (_logger *Logger) LogN(msg string, o ...any) { _logger.log(LOG_NONE, msg, o...) }
func (_logger *Logger) LogE(msg string, o ...any) { _logger.log(LOG_ERROR, msg, o...) }
func (_logger *Logger) LogW(msg string, o ...any) { _logger.log(LOG_WARN, msg, o...) }
func (_logger *Logger) LogI(msg string, o ...any) { _logger.log(LOG_INFO, msg, o...) }
func (_logger *Logger) LogD(msg string, o ...any) { _logger.log(LOG_DEBUG, msg, o...) }
func (_logger *Logger) LogV(msg string, o ...any) { _logger.log(LOG_VERBOSE, msg, o...) }

func (_logger *Logger) Flush() {
	_logger.wg.Wait()
}

func (_logger *Logger) Close() {
	_logger.Flush()
	close(_logger.queue)
	_logger.file.Close()
}
