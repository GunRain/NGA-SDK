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
	"io"
	"os"
	"path/filepath"
)

func exist(fileName string) bool {
	_, err := os.Stat(fileName)
	return !os.IsNotExist(err)
}

func MvFile(src, dst string) bool {
	if dstDir := filepath.Dir(dst); !exist(dstDir) {
		if err := os.MkdirAll(dstDir, os.ModePerm); err != nil {
			return false
		}
	}
	srcInfo, err := os.Stat(src)
	if err != nil {
		return false
	}
	atime, mtime := srcInfo.ModTime(), srcInfo.ModTime()
	defer func() {
		if exist(dst) {
			_ = os.Chtimes(dst, atime, mtime)
		}
	}()
	err = os.Rename(src, dst)
	if err == nil {
		return true
	}
	if !func() bool {
		srcFile, err := os.Open(src)
		if err != nil {
			return false
		}
		defer srcFile.Close()
		dstFile, err := os.Create(dst)
		if err != nil {
			return false
		}
		defer dstFile.Close()
		_, err = io.Copy(dstFile, srcFile)
		if err != nil {
			_ = os.Remove(dst)
			return false
		}
		return true
	}() {
		return false
	}
	if err = os.Remove(src); err != nil {
		return false
	}
	return true
}
