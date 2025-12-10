import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submitBtn", "loader"]

  showLoader(event) {
    // Hide the submit button
    if (this.hasSubmitBtnTarget) {
      this.submitBtnTarget.style.display = "none"
    }

    // Show the loader
    if (this.hasLoaderTarget) {
      this.loaderTarget.classList.remove("hidden")
    }
  }
}
