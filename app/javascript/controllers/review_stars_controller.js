import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["stars", "input"]

  connect() {
    this.current = parseInt(this.inputTarget.value || 0)
    this.updateStars(this.current)
  }

  select(event) {
    const value = parseInt(event.currentTarget.dataset.value)
    this.current = value
    this.inputTarget.value = value
    this.updateStars(value)
  }

  hover(event) {
    const value = parseInt(event.currentTarget.dataset.value)
    this.updateStars(value)
  }

  reset() {
    this.updateStars(this.current)
  }

  updateStars(value) {
    this.starsTarget.querySelectorAll(".star").forEach(star => {
      const starValue = parseInt(star.dataset.value)
      star.textContent = starValue <= value ? "★" : "☆"
    })
  }
}
