package main

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"time"

	"github.com/edgedb/edgedb-go"
)

func main() {
	ctx := context.Background()
	client, err := edgedb.CreateClient(ctx, edgedb.Options{})
	check(err)

	defer client.Close()

	recipes := readRecipes()

	for _, recipe := range recipes {
		var inserted struct{ id edgedb.UUID }
		err = client.QuerySingle(ctx, `INSERT Recipe {
			external_id				:=		<str>$0,
            names 					:= 		<array<str>>$1,
            description 			:= 		<str>$2,
			recipe_steps			:=		<array<json>>$3,
			total_time				:=		<duration>$4,
			servings				:=		<str>$5,
			public					:=		<bool>$6,
			spice_level				:=		<SpiceLevel>$7,
			region					:=		<str>$8,
			owner               	:=		(select User filter .external_id = <str>$9),
			image_id              	:=		<str>$10,
			ingredient_instructions	:=      (insert Instruction {

			}),
			cuisine					:=		<str>$12,
			ingredients				:=		(select Ingredient filter .id in <uuid>$13),
			overnight_preparation 	:=		<bool>$14,
			collections				:=		array_unpack(<array<str>>$15),
			last_modified			:=		<datetime>$16
		}
		unless conflict on .external_id;
			`,
			&inserted,
			recipe.Id,
			recipe.Names,
			recipe.Description,
			recipe.Steps,
			fmt.Sprint(recipe.TotalTimeInMinutes, "minutes"),
			recipe.Servings,
			recipe.Approved,
			recipe.SpiceLevel,
			recipe.Region,
			recipe.ChefId,
			recipe.ImageId,
			recipe.Ingredients,
			recipe.Cuisine,
			recipe.IngredientIds,
			recipe.OvernightPreparation,
			recipe.Collections,
			recipe.LastModified)
		if isConstraintViolation(err) {
			if err.Error() != "edgedb.ConstraintViolationError: external_id violates exclusivity constraint" {
				log.Println(err, ", skipping", recipe.Id)
			}
			continue
		} else {
			check(err)
		}
	}

	for _, recipe := range recipes {
		if recipe.AccompanimentIds != nil {
			err = client.QuerySingle(ctx, `UPDATE Recipe
				filter .external_id = <str>$0
				set {
					accompaniments := (SELECT Recipe
						filter .external_id in array_unpack(<array<str>>$1)
					)
				}`, nil, recipe.Id, recipe.AccompanimentIds)
			if !isNoData(err) {
				check(err)
			}
		}
	}
}

func readRecipes() []Recipe {
	dir := "../../../../data/recipes"
	c, err := os.ReadDir(dir)
	check(err)

	var recipes []Recipe

	for _, entry := range c {
		b, err := os.ReadFile(filepath.Join(dir, entry.Name()))
		check(err)
		var recipe Recipe
		json.Unmarshal(b, &recipe)
		recipes = append(recipes, recipe)
	}

	return recipes
}

func isConstraintViolation(err error) bool {
	var edbErr edgedb.Error
	if !errors.As(err, &edbErr) {
		return false
	}
	return edbErr.Category(edgedb.ConstraintViolationError)
}

func isNoData(err error) bool {
	var edbErr edgedb.Error
	if !errors.As(err, &edbErr) {
		return false
	}
	return edbErr.Category(edgedb.NoDataError)
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

type Recipe struct {
	Id                   string
	Names                []string
	Description          string
	Steps                []Step
	TotalTimeInMinutes   int16
	Servings             string
	Approved             bool
	SpiceLevel           string
	Region               string
	ChefId               string
	ImageId              string
	Ingredients          []Step
	Cuisine              string
	IngredientIds        []string
	OvernightPreparation bool
	Collections          []string
	AccompanimentIds     []string
	LastModified         time.Time
}

type Step struct {
	Text      string
	Decorator string
}
