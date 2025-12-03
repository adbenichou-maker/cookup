// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import FilterController from "./filter_controller"
application.register("filter", FilterController)

import RatingController from "./rating_controller"
application.register("rating", RatingController)

import DifficultySliderController from "./difficulty_slider_controller"
application.register("difficultySlider", DifficultySliderController)
