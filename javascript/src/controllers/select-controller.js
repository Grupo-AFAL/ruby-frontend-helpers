import { Controller } from 'stimulus'
import autoCompleteInput from '../utils/autoCompleteInput'

/**
 * Select Controller
 *
 * Converts a text input into a single select input with the ability to
 * autocomplete existing items.
 */
export class SelectController extends Controller {
  async connect () {
    this.selectField = this.element.querySelector('select')
    this.selectField.setAttribute('hidden', '')

    this.initializeItems()

    autoCompleteInput(this, {
      className: 'is-fullwidth',
      placeholder: this.extractplaceholderText()
    })
  }

  initializeItems () {
    this.selectedValue = this.selectField.selectedOptions[0].value
    this.options = Array.from(this.selectField.options)
    this.items = this.options
      .filter(o => o.value.length > 0)
      .map(o => [o.text, o.value])

    this.itemsByValue = this.items.reduce((accumulator, item) => {
      const [name, value] = item
      accumulator[value] = name
      return accumulator
    }, {})
  }

  commit () {
    const selectedOption = this.selectField.querySelector('option[selected]')
    if (selectedOption) selectedOption.removeAttribute('selected')

    this.selectField
      .querySelector(`option[value='${this.selectedValue}']`)
      .setAttribute('selected', '')
  }

  extractplaceholderText () {
    const placeholderOption = this.options.filter(o => o.value.length === 0)[0]
    if (placeholderOption) {
      return placeholderOption.innerText
    }
  }
}
