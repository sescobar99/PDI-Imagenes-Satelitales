classdef DataLoader
    properties 
       images
       last
       size = 0
    end
    methods (Access = public)
        function obj = initialize(obj,folder)
            obj.images = dlnode();
            obj = obj.createImagesList(folder);
        end 
        function obj = createImagesList(obj,folder)
            first = true;
            files = dir(fullfile(folder,'*.jpg')); % pattern to match filenames.
            for k = 1:numel(files)
                baseFileName = files(k).name;
                fullFileName = fullfile(folder, baseFileName);
                splited = split(fullFileName, '_');
                fecha = splited(5);
                year = extractBetween(fecha,1,4);
                month = extractBetween(fecha,5,6);
                day = extractBetween(fecha,7,8);
                im = SatellitalImage();
                im.imagePath = fullFileName;
                im.year = year;
                im.month = month;
                im.day = day;
                if(first == true)
                    obj.images.Data = im;
                    obj.last = obj.images;
                    first = false;
                else
                    aux = dlnode(im);
                    obj.insert(aux);
                    obj.last = aux;
                end
                obj.size = obj.size+1;
            end
        end
        function image = getElement(obj,idx)
            image = obj.images;
            for k = 1:idx-1
                image = image.Next;
            end
        end
        function obj = insert(obj, node)
            encontrado = false;
            al = obj.images;
            while ~encontrado
                if(isempty(al.Next))
                    node.insertAfter(al);
                    break
                end
                year = al.Data.year;
                month = al.Data.month;
                day = al.Data.day;
                if(node.Data.year > year)
                    al = al.Next;
                elseif(node.Data.year == year && node.Data.month > month)
                    al = al.Next;
                elseif(node.Data.year == year && node.Data.month == month && node.Data.day > day)
                    al = al.Next;
                elseif(node.Data.year == year && node.Data.month == month && node.Data.day == day)
                    node.insertAfter(al);
                    encontrado = true;
                elseif(node.Data.year == year && node.Data.month == month && node.Data.day < day)
                    node.insertBefore(al)
                    encontrado = true;
                elseif(node.Data.year == year && node.Data.month < month)
                    node.insertBefore(al)
                    encontrado = true;
                elseif(node.Data.year < year)
                    node.insertBefore(al)
                    encontrado = true;
                end
                
            end
        end
    end
end
