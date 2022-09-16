select
	*
from
	Portofolio..houseville

-- standarize date format

select
	saledateconverted,
	convert(date,saledate)
from
	Portofolio..houseville

update
	portofolio..houseville
set 
	saledate=convert(date,saledate)

-- another option to do this (the better option)
alter table
	portofolio..houseville
add
	saledateconverted date

update
	portofolio..houseville
set
	saledateconverted=convert(date,saledate)

-----------------------------------------------------------------
-- populate property address data

select
	*
from
	Portofolio..houseville
--where
--	PropertyAddress is null
order by
	ParcelID


select
	t1.ParcelID,
	t1.PropertyAddress,
	t2.ParcelID,
	t2.PropertyAddress,
	ISNULL(t1.propertyaddress,t2.PropertyAddress)
from
	Portofolio..houseville as t1
	join
	Portofolio..houseville as t2
	on
	t1.ParcelID=t2.ParcelID
	and
	t1.[UniqueID ]<>t2.[UniqueID ]
where
	t1.PropertyAddress is null



update
	t1
set
	propertyaddress=ISNULL(t1.propertyaddress,t2.PropertyAddress)
from
	Portofolio..houseville as t1
	join
	Portofolio..houseville as t2
	on
	t1.ParcelID=t2.ParcelID
	and
	t1.[UniqueID ]<>t2.[UniqueID ]
where
	t1.PropertyAddress is null



----------------------------------------------------
-- breaking out address into individual columns (address, city, state)

select
	PropertyAddress
from
	Portofolio..houseville

--seperate with comma

select
	substring(propertyaddress,1,charindex(',',propertyaddress)-1) as Address,
	substring(propertyaddress,charindex(',',propertyaddress)+1, len(PropertyAddress)) as city
from
	Portofolio..houseville


alter table
	portofolio..houseville
add
	propertysplitaddress nvarchar(255)

update
	portofolio..houseville
set
	propertysplitaddress=substring(propertyaddress,1,charindex(',',propertyaddress)-1)

alter table
	portofolio..houseville
add
	propertysplitcity nvarchar(255)

update
	portofolio..houseville
set
	propertysplitcity=substring(propertyaddress,charindex(',',propertyaddress)+1, len(PropertyAddress))




select
	*
from
	Portofolio..houseville



-- other option to break coma


select
	OwnerAddress
from
	Portofolio..houseville


select
	parsename(replace(owneraddress,',','.'),3),
	parsename(replace(owneraddress,',','.'),2),
	parsename(replace(owneraddress,',','.'),1)
from
	Portofolio..houseville


alter table
	portofolio..houseville
add
	ownersplitaddress nvarchar(255)

update
	portofolio..houseville
set
	ownersplitaddress=parsename(replace(owneraddress,',','.'),3)

alter table
	portofolio..houseville
add
	ownersplitcity nvarchar(255)

update
	portofolio..houseville
set
	ownersplitcity=parsename(replace(owneraddress,',','.'),2)

alter table
	portofolio..houseville
add
	ownersplitstate nvarchar(255)

update
	portofolio..houseville
set
	ownersplitstate=parsename(replace(owneraddress,',','.'),1)






----------------------------------------------------------------------------
-- change Y and N and to yes and no "sold as vacant" field

select distinct
	soldasvacant,
	count(soldasvacant)
from
	Portofolio..Houseville
group by
	SoldAsVacant
order by
	2




select
	SoldAsVacant,
	case when SoldAsVacant='y' then 'Yes'
		 when SoldAsVacant='n' then 'No'
		 else SoldAsVacant
	end
from
	Portofolio..Houseville


update
	portofolio..houseville
set
	SoldAsVacant=case when SoldAsVacant='y' then 'Yes'
		 when SoldAsVacant='n' then 'No'
		 else SoldAsVacant
	end



--------------------------------------------------------------
-- remove duplicates

with rownumCTE as (
select
	*,
	row_number() over(
	partition by parcelid,
				 propertyaddress,
				 saleprice,
				 saledate,
				 legalreference
				 order by
					uniqueid
					) row_num

from
	portofolio..houseville
--order by
--	ParcelID
)
select
	*
from
	rownumCTE
where
	row_num>1




select
	*
from
	portofolio..houseville



---------------------------------------------------------
-- delete unused columns

select
	*
from
	portofolio..houseville


alter table
	portofolio..houseville
drop column
	saledate