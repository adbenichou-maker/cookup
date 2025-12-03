import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["stars", "input"]

  connect() {
    this.updateStars()
  }

  select(event) {
    const value = event.currentTarget.dataset.ratingValue
    this.inputTarget.value = value
    this.updateStars()
  }

  updateStars() {
    const current = parseInt(this.inputTarget.value || 0)

    this.starsTarget.querySelectorAll(".star").forEach(star => {
      const val = parseInt(star.dataset.ratingValue)
      star.textContent = val <= current ? "★" : "☆"
    })
  }
}
