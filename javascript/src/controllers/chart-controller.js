import { Controller } from 'stimulus'

/**
 * ChartController
 * Uses the chartkick and charts.js library to render charts
 * https://github.com/ankane/chartkick.js
 *
 * Chart Types:
 * - LineChart
 * - PieChart
 * - ColumnChart
 * - BarChart
 * - AreaChart
 * - ScatterChart
 * - GeoChart
 * - Timeline
 *
 * How to use:
 *
 * <div id="any-id" data-controller="chart" data-chart-data="{}" data-chart-type="LineChart">
 *   Cargando...
 * </div>
 */
export class ChartController extends Controller {
  async connect () {
    const { default: Chartkick } = await import('chartkick')
    const { default: Chart } = await import('chart.js') // eslint-disable-line

    const chartType = this.data.get('type')
    const data = JSON.parse(this.data.get('data'))
    const elementId = this.element.id

    this.chart = new Chartkick[chartType](elementId, data, {})
  }
}
