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

package nga

import (
	"fmt"
	"os"
	"path/filepath"
	"sync"
	"time"
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

var logLevelStrs = map[LogLevel]string{
	LOG_NONE:    "?",
	LOG_ERROR:   "E",
	LOG_WARN:    "W",
	LOG_INFO:    "I",
	LOG_DEBUG:   "D",
	LOG_VERBOSE: "V",
}

type Logger struct {
	file  *os.File
	lv    LogLevel
	queue chan string
	wg    sync.WaitGroup
	close chan struct{}
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
		file:  file,
		lv:    lv,
		queue: make(chan string, 100),
		close: make(chan struct{}),
	}
	go func() {
		for {
			select {
			case logMessage := <-logger.queue:
				_, _ = logger.file.WriteString(logMessage + "\n")
				logger.wg.Done()
			case <-logger.close:
				return
			}
		}
	}()
	return logger, nil
}

func (l *Logger) log(lv LogLevel, msg string) {
	if lv <= l.lv {
		l.wg.Add(1)
		l.queue <- fmt.Sprintf("%s [%s] %s", time.Now().Format("01-02 15:04:05"), logLevelStrs[lv], msg)
	}
}

func (l *Logger) LogN(msg string, o ...any) {
	l.log(LOG_NONE, fmt.Sprintf(msg, o...))
}

func (l *Logger) LogE(msg string, o ...any) {
	l.log(LOG_ERROR, fmt.Sprintf(msg, o...))
}

func (l *Logger) LogW(msg string, o ...any) {
	l.log(LOG_WARN, fmt.Sprintf(msg, o...))
}

func (l *Logger) LogI(msg string, o ...any) {
	l.log(LOG_INFO, fmt.Sprintf(msg, o...))
}

func (l *Logger) LogD(msg string, o ...any) {
	l.log(LOG_DEBUG, fmt.Sprintf(msg, o...))
}

func (l *Logger) LogV(msg string, o ...any) {
	l.log(LOG_VERBOSE, fmt.Sprintf(msg, o...))
}

func (l *Logger) Flush() {
	l.wg.Wait()
}

func (l *Logger) Close() {
	l.Flush()
	close(l.close)
	l.file.Close()
}
