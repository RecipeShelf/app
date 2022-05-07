package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"reflect"
	"sort"
	"strings"
)

func main() {
	dir := os.Args[1]

	if len(os.Args) == 3 {
		printProperties(dir, &os.Args[2])
	} else {
		printProperties(dir, nil)
	}
}

func printProperties(dir string, propertyName *string) {
	c, err := os.ReadDir(dir)
	check(err)

	properties := make(map[string]struct{})
	for _, entry := range c {
		if entry.IsDir() {
			continue
		}

		byteValue, err := os.ReadFile(filepath.Join(dir, entry.Name()))
		check(err)

		json := UnmarshalJSON([]byte(byteValue))

		for _, jsonElement := range json {
			property := readPropertyValue(jsonElement, propertyName)
			if property != nil {
				switch v := property.(type) {
				case string:
					properties[v] = struct{}{}
				case []string:
					for _, p := range v {
						properties[p] = struct{}{}
					}
				case []interface{}:
					for _, p := range v {
						properties[p.(string)] = struct{}{}
					}
				default:
					fmt.Println(reflect.TypeOf(property))
				}
			}
		}
	}

	values := make([]string, 0)
	for value := range properties {
		values = append(values, "'"+value+"'")
	}
	sort.Strings(values)
	fmt.Println("\r\n(" + strings.Join(values, ",") + ")\r\n")
}

func readPropertyValue(obj map[string]interface{}, propertyName *string) interface{} {
	if propertyName != nil {
		return obj[*propertyName]
	} else {
		keys := make([]string, 0)
		for key := range obj {
			keys = append(keys, key)
		}
		return keys
	}
}

func UnmarshalJSON(b []byte) []map[string]interface{} {
	if len(b) == 0 {
		return make([]map[string]interface{}, 0)
	}
	// See if we can guess based on the first character
	switch b[0] {
	case '{':
		return unmarshalSingle(b)
	case '[':
		return unmarshalMany(b)
	}
	return make([]map[string]interface{}, 0)
}

func unmarshalSingle(b []byte) []map[string]interface{} {
	var result map[string]interface{}
	err := json.Unmarshal(b, &result)
	check(err)
	var results = make([]map[string]interface{}, 1)
	results[0] = result
	return results
}

func unmarshalMany(b []byte) []map[string]interface{} {
	var result []map[string]interface{}
	err := json.Unmarshal(b, &result)
	check(err)
	return result
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}
