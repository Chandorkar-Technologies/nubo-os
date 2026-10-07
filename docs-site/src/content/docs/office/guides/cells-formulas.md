---
title: "Use formulas"
description: "Write formulas, use the function groups on the Formulas tab, and find a function in Nubo Cells."
sidebar:
  order: 70
---

**Applies to:** Nubo Cells

A formula starts with `=`. It can use numbers, cell names and functions.

## Examples

| You want | Type |
|---|---|
| Add two cells | `=B2+C2` |
| Subtract | `=B2-C2` |
| Add a column | `=SUM(B2:B7)` |
| An average | `=AVERAGE(B2:B7)` |
| The largest value | `=MAX(B2:B7)` |
| A choice | `=IF(D2>0,"profit","loss")` |
| Count numbers | `=COUNT(B2:B7)` |

A range is written `B2:B7`. A function that works across several sheets or documents uses the same names.

## The Formulas tab

Open **Formulas**. The **Function Library** group has:

- **Insert Function**, a list of every function with a short help for each.
- **AutoSum** adds the numbers above or beside the cell.
- **Logical**, **Date & Time**, **Math & Trig**, **Financial**, **Text** and **Lookup & Reference**: each opens a short list of the functions in that family.
- **More Functions** has the rest.

The **Range** group has **Define Range**, **Select Range** and **Refresh Range**, to give a block of cells a name. **Formula to Value** replaces a formula with the number it gives. **Recalculate** recomputes everything.

## Steps: add a formula with a function

1. Select the cell that should show the answer.
2. Open **Formulas**, then **AutoSum**, or **Insert Function** to pick a function.
3. Select the cells it should use, and press <kbd>Enter</kbd>.

## Verify

The cell shows the answer. Click it and the formula is in the formula bar.

## Troubleshooting

- **`#NAME?`.** The function name is spelled wrong, or a name has not been defined.
- **`#VALUE!`.** A cell the formula uses holds text where a number is needed.
- **`#DIV/0!`.** The formula divides by zero or by an empty cell.

## See also

- [Build your first spreadsheet](/office/guides/cells-first-spreadsheet/)
- [Nubo Cells ribbon reference](/office/reference/ribbon-cells/)
