import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.launchConfetti()
  }

  launchConfetti() {
    // Load confetti script dynamically
    const script = document.createElement("script")
    script.src = "https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"
    script.onload = () => {
      // Spray confetti twice for effect
      confetti({
        particleCount: 120,
        spread: 70,
        origin: { y: 0.6 }
      })

      setTimeout(() => {
        confetti({
          particleCount: 80,
          spread: 90,
          origin: { y: 0.7 }
        })
      }, 400)
    }

    document.body.appendChild(script)
  }
}
