import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "emoji", "name", "level", "description"]
  static values = {
    badges: Array
  }

  connect() {
    if (this.badgesValue.length > 0) {
      this.currentIndex = 0
      this.showBadge(this.currentIndex)
    }
  }

  showBadge(index) {
    const badge = this.badgesValue[index]
    if (!badge) return

    this.emojiTarget.textContent = badge.emoji
    this.nameTarget.textContent = badge.name
    this.levelTarget.textContent = badge.level_name
    this.levelTarget.className = `badge-notification-level badge-level-${badge.level}`
    this.descriptionTarget.textContent = badge.upgraded
      ? `Upgraded to ${badge.level_name}!`
      : badge.description

    this.overlayTarget.classList.add("visible")
    this.launchConfetti()
  }

  launchConfetti() {
    if (window.confetti) {
      this.fireConfetti()
      return
    }

    const script = document.createElement("script")
    script.src = "https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"
    script.onload = () => this.fireConfetti()
    document.body.appendChild(script)
  }

  fireConfetti() {
    const colors = this.getConfettiColors()

    // Initial burst from center
    confetti({
      particleCount: 100,
      spread: 70,
      origin: { y: 0.6 },
      colors: colors
    })

    // Side cannons
    setTimeout(() => {
      confetti({
        particleCount: 50,
        angle: 60,
        spread: 55,
        origin: { x: 0, y: 0.6 },
        colors: colors
      })
      confetti({
        particleCount: 50,
        angle: 120,
        spread: 55,
        origin: { x: 1, y: 0.6 },
        colors: colors
      })
    }, 200)

    // Star burst
    setTimeout(() => {
      confetti({
        particleCount: 80,
        spread: 100,
        origin: { y: 0.5 },
        colors: colors,
        shapes: ['star'],
        scalar: 1.2
      })
    }, 400)
  }

  getConfettiColors() {
    const badge = this.badgesValue[this.currentIndex]
    switch (badge.level) {
      case 1: return ['#cd7f32', '#b87333', '#d4a574'] // Bronze
      case 2: return ['#C0C0C0', '#A8A8A8', '#D3D3D3'] // Silver
      case 3: return ['#FFD700', '#FFC125', '#FFDF00'] // Gold
      case 4: return ['#E5E4E2', '#B9B9B9', '#FFFFFF'] // Platinum
      default: return ['#8BAA7B', '#FFD700', '#FF6B6B']
    }
  }

  close() {
    this.overlayTarget.classList.remove("visible")
    this.overlayTarget.classList.add("closing")

    setTimeout(() => {
      this.overlayTarget.classList.remove("closing")
      this.currentIndex++

      if (this.currentIndex < this.badgesValue.length) {
        setTimeout(() => this.showBadge(this.currentIndex), 300)
      } else {
        this.element.remove()
      }
    }, 300)
  }

  closeOnBackground(event) {
    if (event.target === this.overlayTarget) {
      this.close()
    }
  }

  stopPropagation(event) {
    event.stopPropagation()
  }
}
