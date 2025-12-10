import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "spinner"]

  showLoading(event) {
    if (this.hasButtonTarget && this.hasSpinnerTarget) {
      // Hide button text, show spinner
      this.buttonTarget.classList.add("ai-submit-btn-loading")
      this.spinnerTarget.classList.remove("hidden")

      // Allow form to submit, then disable button after a tiny delay
      setTimeout(() => {
        this.buttonTarget.disabled = true
      }, 10)
    }
  }
}
