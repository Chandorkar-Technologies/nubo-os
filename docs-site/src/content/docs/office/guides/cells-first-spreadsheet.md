---
title: "Build your first spreadsheet"
description: "Enter data, add totals, format numbers and save a small budget in Nubo Cells."
sidebar:
  order: 60
---

**Applies to:** Nubo Cells

You will build a six-month budget with totals.

## Before you begin

Nubo Office is installed.

## Steps

1. Open **Nubo Cells**. A blank sheet opens with cell **A1** selected. The name of the cell is in the box at the left of the formula bar.
2. Type the headings in row 1: `Month`, `Income`, `Costs`, `Profit`. Press <kbd>Tab</kbd> to move right, and <kbd>Enter</kbd> to move down.
3. Type the months in column A and the income and costs in columns B and C.
4. In D2, type `=B2-C2` and press <kbd>Enter</kbd>. The cell shows the profit.
5. Copy that formula down the column: select D2, press <kbd>Ctrl</kbd>+<kbd>C</kbd>, select D3 to D7 and press <kbd>Ctrl</kbd>+<kbd>V</kbd>. Or select D2 to D7 and press <kbd>Ctrl</kbd>+<kbd>D</kbd> to fill down.
6. Under the last month, type `Total`. In B8, type `=SUM(B2:B7)`. Copy it across to C8 and D8.
7. Make the headings stand out: select row 1 and choose **Bold** on the **Home** tab, then colour the cells.
8. Format the numbers: select the Income to Profit cells and choose a format in the **Number** group on Home.
9. Name the sheet: double-click the tab at the bottom, or use its context menu. <!-- verify label: rename sheet -->
10. Save with <kbd>Ctrl</kbd>+<kbd>S</kbd>. Choose `.xlsx` to share with Excel users, or `.ods`.

## Verify

The totals add up. Change an income figure and the profit and totals change at once.

## Troubleshooting

- **A cell shows `###`.** The column is too narrow. Widen it, or use **Set Optimal Column Width**, <kbd>Ctrl</kbd>+<kbd>3</kbd>.
- **A formula shows as text.** The cell was formatted as text. Change its format to General and retype the formula.

## See also

- [Use formulas](/office/guides/cells-formulas/)
- [Make a chart](/office/guides/cells-charts/)
