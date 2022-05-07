package main

import (
	"context"
	"encoding/json"
	"errors"
	"log"
	"os"
	"time"

	"github.com/edgedb/edgedb-go"
)

func main() {
	ctx := context.Background()
	client, err := edgedb.CreateClient(ctx, edgedb.Options{})
	check(err)

	defer client.Close()

	ingredients := readIngredients()

	for _, ingredient := range ingredients {
		var inserted struct{ id edgedb.UUID }
		err = client.QuerySingle(ctx, `INSERT Ingredient {
            names 			:= 		<array<str>>$0,
            description 	:= 		<str>$1,
			category 		:=		<str>$2,
			vegan	 		:=		<bool>$3,
			last_modified	:=		<datetime>$4,
			external_id		:=		<str>$5 }`,
			&inserted, ingredient.Names, ingredient.Description, ingredient.Category,
			ingredient.Vegan, ingredient.LastModified, ingredient.Id)
		if isConstraintViolation(err) {
			if err.Error() != "edgedb.ConstraintViolationError: external_id violates exclusivity constraint" {
				log.Println(err, ", skipping", ingredient.Id)
			}
			continue
		} else {
			check(err)
		}
	}
}

func readIngredients() []Ingredient {
	file := "../../../../data/ingredients.json"
	b, err := os.ReadFile(file)
	check(err)

	var result []Ingredient
	err = json.Unmarshal(b, &result)
	check(err)

	return result
}

func isConstraintViolation(err error) bool {
	var edbErr edgedb.Error
	if !errors.As(err, &edbErr) {
		return false
	}
	return edbErr.Category(edgedb.ConstraintViolationError)
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

type Ingredient struct {
	Id           string
	Names        []string
	Description  string
	Category     string
	Vegan        bool
	LastModified time.Time
}
