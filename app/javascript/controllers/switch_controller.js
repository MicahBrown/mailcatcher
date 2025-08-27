import { Controller } from "@hotwired/stimulus"

// "switch" works similarily to "toggler" except it's for a collection of toggles that can toggle multiple containers
// example: you have a list of checkboxes and each checkbox has its own set of subfields that get toggled when active

// Connects to data-controller="switch"
export default class extends Controller {
  static targets = ["switch", "item"]
  static values = {
    disableInputs: Boolean, // may not work if nested fields need [disabled] attr control
    scope: Array,
    consumeChildSwitches: Boolean,
    toggle: {
      type: Boolean,
      default: true
    }
  }

  connect() {
    const klass = this
    console.log(klass)

    // add slight delay to allow child switch controllers to initialize (for consumeChildSwitches)
    setTimeout(function(){
      klass.toggle()
    }, 200)
  }

  toggle() {
    let klass = this
    klass.hideAll()

    let activeSwitches = this.switchTargets.filter(function(s){ return klass.isSwitchActive(s) })

    activeSwitches.forEach(function(s){
      klass.getItems(s).forEach(function(i){
        klass.show(i)

        if (klass.recalcStickyValue)
          klass.recalcSticky()
      })
    })
    this.dispatch("toggle")
  }

  reset() {
    this.hideAll()
    this.switchTargets.forEach((s) => {
      if (s.tagName == "INPUT" && (s.type == "checkbox" || s.type == "radio")) {
        s.checked = false
      } else if (s.tagName == "SELECT") {
        s.selectedIndex = -1
      }
    })

    return true
  }

  getItems(s) {
    if (s.tagName ==  "SELECT") {
      let items = new Array

      Array.from(s.selectedOptions).map((o) => {
        let id = o.dataset.switchTargetParam
        if (id === undefined)
          id = o.value // use option value as backup option for switch ID

        items = items.concat(this.filterItems(id))
      })

      return items
    } else {
      return this.filterItems(s.dataset.switchTargetParam)
    }
  }

  filterItems(id) {
    return this.scopedItems().filter(function(i){ return i.dataset.switchId == id })
  }

  scopeItems(items){
    const klass = this
    return items.filter(function(i){ return klass.scopeValue.length > 0 ? klass.scopeValue.includes(i.dataset.switchId) : true })
  }

  scopedItems() {
    const klass = this
    let targets = klass.scopeItems(klass.itemTargets)

    if (this.consumeChildSwitchesValue) {
      klass.element.querySelectorAll("[data-controller='switch']").forEach(function(el){
        let consumedSwitch = klass.application.getControllerForElementAndIdentifier(el, "switch")

        klass.scopeItems(consumedSwitch.itemTargets).forEach(function(t){
          targets.push(t)
        })
      })
    }

    return targets
  }

  isSwitchActive(s) {
    if (s.tagName == "SELECT") {
      return s.selectedOptions.length > 0
    } else if (s.tagName == "INPUT" && (s.type == "checkbox" || s.type == "radio")) {
      return s.checked
    } else {
      alert("invalid switch type")
    }
  }

  hideAll() {
    let klass = this
    klass.scopedItems().forEach(function(item){
      klass.hide(item)
    })
  }

  show(item) {
    // disable nested inputs inside switch item
    if (this.disableInputsValue) {
      item.querySelectorAll("input, textarea, select").forEach(function(inp){
        inp.disabled = false
      })
    }

    if (this.toggleValue)
      item.classList.remove("is-hidden")
  }

  hide(item) {
    // enable nested inputs inside switch item
    if (this.disableInputsValue) {
      item.querySelectorAll("input, textarea, select").forEach(function(inp){
        inp.disabled = true
      })
    }

    if (this.toggleValue)
      item.classList.add("is-hidden")
  }
}
