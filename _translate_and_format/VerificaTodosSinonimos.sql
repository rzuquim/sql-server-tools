declare @i int 
set @i = 1

declare @object_id int
declare @query varchar(2000)
declare @name varchar(200)

select @object_id = min( object_id )
	from sys.synonyms

while @object_id is not null

begin
	select @name = name from sys.synonyms where object_id = @object_id
	set @query = 'select top 1 '''+ @name + ''', * from ' + @name
	
	exec(@query)
	
    -- do stuff
    select @object_id = min( object_id )
    from sys.synonyms where object_id > @object_id
end



