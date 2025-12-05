import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "name", "description", "rank", "emoji"]

  connect() {
    console.log("Badge controller connected")
  }

  open(event) {
    console.log("badge open fired", event.currentTarget)
    const el = event.currentTarget

    const name = el.dataset.badgeName || "Unknown"
    const description = el.dataset.badgeDescription || "No description"
    const level = parseInt(el.dataset.badgeLevel || "0", 10)
    const emoji = el.dataset.badgeEmoji || ""

    const ranks = {
      0: "Not unlocked",
      1: "Bronze",
      2: "Silver",
      3: "Gold",
      4: "Platinum"
    }

    this.nameTarget.textContent = name
    this.descriptionTarget.textContent = description
    this.rankTarget.textContent = ranks[level] || "Unknown"
    this.emojiTarget.textContent = emoji

    this.overlayTarget.classList.remove("hidden")
    this.overlayTarget.classList.add("visible")
  }

  close() {
    this.overlayTarget.classList.add("hidden")
    this.overlayTarget.classList.remove("visible")
  }

  closeOverlayBackground(event) {
    if (event.target === this.overlayTarget) {
      this.close()
    }
  }

  stopPropagation(event) {
    event.stopPropagation()
  }
}
