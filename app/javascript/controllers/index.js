import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

eagerLoadControllersFrom("controllers", application)

// register extra controllers (if custom)
import BadgeController from "./badge_controller"
application.register("badge", BadgeController)

import BadgeNotificationController from "./badge_notification_controller"
application.register("badge-notification", BadgeNotificationController)

import FilterController from "./filter_controller"
application.register("filter", FilterController)

import RatingController from "./rating_controller"
application.register("rating", RatingController)

import DifficultySliderController from "./difficulty_slider_controller"
application.register("difficultySlider", DifficultySliderController)

import PrepTimeController from "./prep_time_controller"
application.register("prepTime", PrepTimeController)

import RecipeLoaderController from "./recipe_loader_controller"
application.register("recipe-loader", RecipeLoaderController)
