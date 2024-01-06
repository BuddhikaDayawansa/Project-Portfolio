SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [trainDB].[dbo].[Nashville_housing_data]

  ---Select all the data from Nashville housing data---
Select * From [trainDB].[dbo].[Nashville_housing_data]

--- Change the date format to yyyy-MM-dd, remove time data from SaleDate column---

ALTER TABLE [trainDB].[dbo].[Nashville_housing_data] ALTER COLUMN SaleDate DATE
Select SaleDate  From [trainDB].[dbo].[Nashville_housing_data]


Select * From [trainDB].[dbo].[Nashville_housing_data]

----Check the Null Values within Property Address----
Select ParcelID, PropertyAddress from [trainDB].[dbo].[Nashville_housing_data]
Where PropertyAddress is NULL  

---- For the same parcel ID, property address also same, hence we can fill property address for those parcel Ids with address---
-----for the purpose , we will be using innner join to the same table----
Select a.[UniqueID ],a.ParcelID,a.PropertyAddress,b.[UniqueID ],b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)

From [trainDB].[dbo].[Nashville_housing_data] a
JOIN  [trainDB].[dbo].[Nashville_housing_data] b
	on a.ParcelID = b.ParcelID
	And  
	a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is NUll

ALTER TABLE [trainDB].[dbo].[Nashville_housing_data] ALTER COLUMN SaleDate DATE
Select SaleDate  From [trainDB].[dbo].[Nashville_housing_data]

Update a 
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [trainDB].[dbo].[Nashville_housing_data] a
JOIN  [trainDB].[dbo].[Nashville_housing_data] b
	on a.ParcelID = b.ParcelID
	And  
	a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is NUll

--- Check whether there is any null values for PropertyAddress column----
Select ParcelID, PropertyAddress from [trainDB].[dbo].[Nashville_housing_data]
Where PropertyAddress is NULL  

----Get the address and city from PropertyAddress----
Select PropertyAddress from [trainDB].[dbo].[Nashville_housing_data]
 
 --- Split the address by delimeter ',', this will create 2 columns name address and city---
Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as city

from [trainDB].[dbo].[Nashville_housing_data]

-- add 2 columns to the table called PropertySplitAddress, PropertySplitCity ---
ALTER TABLE [trainDB].[dbo].[Nashville_housing_data] ADD  
PropertySplitAddress nvarchar(255)

Update  [trainDB].[dbo].[Nashville_housing_data]
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE [trainDB].[dbo].[Nashville_housing_data] ADD  
PropertySplitCity nvarchar(255)

Update  [trainDB].[dbo].[Nashville_housing_data]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


Select *  From [trainDB].[dbo].[Nashville_housing_data]

--Format the owner address and get 

Select OwnerAddress from [trainDB].[dbo].[Nashville_housing_data]
Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3) as ownerformattedaddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) as ownercity,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) as ownerprovince
 From [trainDB].[dbo].[Nashville_housing_data]

ALTER TABLE [trainDB].[dbo].[Nashville_housing_data] ADD  
OwnerFormattedAddress nvarchar(255)

Update [trainDB].[dbo].[Nashville_housing_data]
Set OwnerFormattedAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE [trainDB].[dbo].[Nashville_housing_data] ADD  
OwnerCity nvarchar(255)

Update [trainDB].[dbo].[Nashville_housing_data]
Set OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE [trainDB].[dbo].[Nashville_housing_data] ADD  
OwnerProvince nvarchar(255)

Update [trainDB].[dbo].[Nashville_housing_data]
Set OwnerProvince = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select *  From [trainDB].[dbo].[Nashville_housing_data]

--Format SoldAsVacant column---

Select distinct SoldAsVacant , COUNT(SoldAsVacant) as YesNoCount
from [trainDB].[dbo].[Nashville_housing_data]
group by SoldAsVacant

Select SoldAsVacant,
Case When SoldAsVacant = 'Y' then 'Yes' 
     When SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 END
From [trainDB].[dbo].[Nashville_housing_data]

Update [trainDB].[dbo].[Nashville_housing_data]
Set SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes' 
     When SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 END

Select distinct SoldAsVacant , COUNT(SoldAsVacant) as YesNoCount
from [trainDB].[dbo].[Nashville_housing_data]
group by SoldAsVacant

---Remove Duplicates----
WITH RowNUMCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY 
		ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY
			UniqueID
			) as row_num


From [trainDB].[dbo].[Nashville_housing_data]
)
Delete  From RowNUMCTE
Where row_num >1 
				
Select *  From [trainDB].[dbo].[Nashville_housing_data]	