classdef DatasetLoader
    properties 
       datasets
       last
       size = 0
    end
    methods (Access = public)
        function obj = initialize(obj)
            obj.datasets = dlnode();
            obj = obj.createDatasetsList();
        end
        function obj = createDatasetsList(obj)
            first = true;
            folder = './Data';
            files = dir(fullfile(folder));
            for k = 1:numel(files)
                baseFileName = files(k).name;
                fullFileName = fullfile(folder, baseFileName);
                if contains(baseFileName, 'SATELLITE')
                    df = Dataset();
                    df.path = fullFileName;
                    nameSplit = split(baseFileName,'_');
                    df.id = cell2mat(nameSplit(2));
                    if(first == true)
                        obj.datasets.Data = df;
                        obj.last = obj.datasets;
                        first = false;
                    else
                        aux = dlnode(df);
                        obj.insert(aux);
                        obj.last = aux;
                    end
                    obj.size = obj.size+1;
                end
                
            end
        end
        function obj = insert(obj, node)
            encontrado = false;
            al = obj.datasets;
            while ~encontrado
                if(isempty(al.Next))
                    node.insertAfter(al);
                    break
                end
                idx = al.Data.id;
                node.Data.id
                idx
                if(node.Data.id > idx)
                    al = al.Next;
                elseif(node.Data.id == idx)
                    node.insertAfter(al);
                    encontrado = true;
                elseif(node.Data.id < idx)
                    node.insertBefore(al)
                    encontrado = true;
                end
            end
        end
        function dataset = getElement(obj,idx)
            dataset = obj.datasets;
            for k = 1:idx-1
                dataset = dataset.Next;
            end
        end
        function array = getAll(obj)
           dataset = obj.datasets;
           array = string.empty;
           size = obj.size;
           for k = 1:size
                array(k) = dataset.Data.path;
                dataset = dataset.Next;
           end
           array(size+1) = 'Crear Nueva'
        end
    end
end