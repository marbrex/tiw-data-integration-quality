---
tags: [TP, OpenRefine, Projet]
aliases: ["Projet OpenRefine"]
---

Task 1 - Explore the dataset
---

### Import the data in OpenRefine

Created a new project in `OpenRefine` with the given [dataset](../assets/openrefine-dataset.csv) downloaded from [Moodle](https://moodle.univ-lyon1.fr/course/view.php?id=506&section=5#tabs-tree-start).

Kept the **default settings**, except:
- "Try to parse text cells as numbers" checked

Once created, there are in total ***27 876* rows**.

### Familiarize with the data

#### Country

##### Duplicates
Since this is a free-format field (i.e. may contain any text input), there are a lot of variants of a same country, differing by letter case, by a whitespace or by one beeing an acronym of another. For instance, for the United States, following values may be found: "`USA`", "`US`", "`U.S.`", "`us`" etc. Thus, generating **duplication** and **inconsistencies** in the dataset. 

#### Industry

##### Duplicates
In the survey, there is an option "Other". If checked, it becomes possible to fill in a custom value. Thus, just as for "Country" field, there are a lot of similar values meaning the same thing, but differing in the way they were spelt. This generates **duplication** and **inconsistencies**.

##### Blank values
For the same reason, this field may be left blank (*71* blank values), but these records remain **valid**, because they represent the "Other" option and express the respondent's unwillingness to detail his answer.

> For a simpler data analysis in the future, these blank values may be replaced with string "Other".

#### Job title

##### Duplicates
As for the "Country" column, multiple variants of a same job title may be encountered. Thus, this generates **duplication** and **inconsistencies**.

##### Incoherent / Invalid values
In addition, there are some incoherent/**invalid** values for this field. For instance, you may see the following value " `-` " given by *2* people, and even this one " `"mum" ;)` ". You may also encounter some `na`, `n\a` values standing for "Not Applicable".

##### Other notes
This column does not contain blank values due to the fact that the values originate from a mandatory field.

#### US States

Due to the fact that this column only gets values from a **white list** of USA, each state is represented by a single value.

Since, this is a multiple choice field, the states are separated by a comma followed by a whitespace. However, may contain blank values.

#### City

##### Duplicates
As for the "Country" column, multiple variants of a same city may be encountered. Thus, generating **duplication** and **inconsistencies**. 

##### Inconsistencies
Among the people working in the US, that is those who have mentioned at least one state, there are some who have provided a city that is not located in neither of these states. Thus, generating **inconsistencies**. 

#### Annual Salary

##### Invalid number format
The vast majority of respondents (*20 302* vs *7 574*) entered a number (in **invalid format**) separating thousands by a comma, which prevented it being parsed as a number by OpenRefine at project's creation. These values should be pre-processed and transformed to numbers.

This problem can be solved by transforming the values as follows (GREL):
```python
value.replaceChars(',', '').toNumber()
```

##### Other notes
There are some **extremely small numbers** for an annual income, or in other words, **outliers** (around *100*-*200* records depending on the threshold and the currency, in general these are amounts below 1000 including **zeros**). While these are valid values for this column, that might still slightly **bias** data analysis' results in the future.

#### Income Currency

##### Inconsistencies and/or Duplication
- Given "Other" as income currency, there are some **duplicate** currencies mentionned in "If other, ..." column, despite being present in the proposed list. For instance, *8* "`USD`", *1* "`US Dollar`" and even *1* "`American Dollars`".

  > "`American Dollars`" could be USD as well as CAD, because both are in America. Nevertheless, because the term "american" is most often referred to USA citizens, the value has been transformed to "`USD`".
  
  > There is as well *1* "`Rupees`", not exactly specified if it is Indonesian, Sri Lankan or something else.. Left the value as it is.

  **Cleaning**
  1) Cluster values using different methods and merge found groups. Repeat until no change.
  2) Perform a manual merge to a few remaining values.
  3) Merge "AUD" and "NZD" as "AUD/NZD".
  4) Transform "Currency" column. Replace "Other" by a value in the proposed list:
  ```python
  whitelist = ["AUD/NZD","CAD","CHF","EUR","GBP","HKD","JPY","SEK","USD","ZAR"]
  other = cells['If "Other," please indicate the currency here:'].value
  return other if other in whitelist else value
  ```
  5) Transform "If Other, ..." column. Unset old values:
  ```python
  currency = cells['Please indicate the currency'].value
  return None if currency == value else value
  ```

- In addition, there are in total *4* people who have mentioned "Other" as their income currency **and** they left the next column as blank. Thus, generating **inconsistencies**.

  Because of the lack of information, we cannot do much about it. The only possibilities are either leave the values as blank, or create a special enumeration value like "Not Specified".

- In contrast, there are as well people (*52*) who have mentioned an income currency from the proposed list, but in addition filled up the next column, hence either duplicating their answer or providing some unnecessary information. Thus, generating **duplication** and/or **inconsistencies**. 

  **Cleaning**
  This issue can be solved by:
  1) Filter currency field by `value != 'Other'` (gives 52 records)
  2) Filter non-null values in the target* field by `!isBlank(value)`
  3) Unset the values in the target* by assigning `null`
  \* **Target:** "if other, ..." column

#### Gender and Race

##### Incoherent / Invalid values
Despite the Gender and Race being values originating from a **white list**, these fields may be left blank. However, in both questions, there is an option to abstain from answering. Thus, blank values may be considered as **invalid** for these fields and transformed to the dedicated value (that is "Prefer not to answer").

### 1.1) How many records have empty fields (if any) ?

To find how many records have **at least 1** empty field, we can proceed as follows:

1) Apply the "Blank records per column" facet on the "All" column
2) Among the results, choose the maximum value.

In this case, the "Other Currency" column has the maximum empty records, that is ***27 676***.

### 1.2) How many records have invalid fields (if any) ?

Since the concrete explanation of what values can be considered as invalid was not given, values are labeled as invalid based on different criterias explained above (In the "Familiarize with the data" section) and depending on its field.

- #### Annual Salary:
  - Invalid number format (*20 302* records)
- 

### 1.3) How many records have duplicated fields (if any) ?

### 1.4) What other inconsistencies are there ?

### 1.5) Reflect also on why these inconsistencies happened

Task 2 - Missing values
---

### 2.1) Explain and motivate how you are handling the missing values

Task 3 - Duplicate values
---

### 3.1) Explain and motivate how you are handling the duplicate values

Task 4 - The inconsistencies
---

### 4.1) Fix the inconsistencies

Task 5 - Improve the dataset
---

