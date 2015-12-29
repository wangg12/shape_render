function shape2cobj(shape, outfile, shapename)

if nargin < 3,
    shapename = outfile;
end

fout = fopen(outfile, 'wt');

E = sort([shape.TRIV(:,2) shape.TRIV(:,3); shape.TRIV(:,1) shape.TRIV(:,3); shape.TRIV(:,1) shape.TRIV(:,2)],2);
[E,i,j] = unique(E,'rows');
ne = size(E,1);

if ~(isfield(shape,'u') & isfield(shape,'v')),
    fprintf(fout, '# OBJ\n');
    %fprintf(fout, '# %s\n', shapename);
else
    fprintf(fout, 'STOFF\n');
end
fprintf(fout, '# %d %d %d\n', length(shape.X), size(shape.TRIV, 1), ne);

if isfield(shape,'u') & isfield(shape,'v') & isfield(shape,'desc'),
    fprintf(fout, 'v %.8f %.8f %.8f %.8f %.8f %.8f\n', [shape.X(:)  shape.Y(:)  shape.Z(:) shape.u(:) shape.v(:) shape.desc(:)]');
elseif isfield(shape,'u') & isfield(shape,'v'),
    fprintf(fout, 'v %.8f %.8f %.8f\n', [shape.X(:)  shape.Y(:)  shape.Z(:)]');
    fprintf(fout, 'vt %.8f %.8f\n', [shape.u(:) shape.v(:)]');
else
    fprintf(fout, 'v %.8f %.8f %.8f\n', [shape.X(:)  shape.Y(:)  shape.Z(:)]');
end

if isfield(shape, 'tri_labels'),
    if size(shape.tri_labels,2) == 1,
        fprintf(fout, 'f %d %d %d %d\n', [shape.TRIV-1 shape.tri_labels(:)]');
    else
        fprintf(fout, 'f %d %d %d %d %d %d\n', [shape.TRIV-1 shape.tri_labels]');
    end
else
    shape.TRIV = [shape.TRIV( :, 1 ), shape.TRIV( :, 1 ), shape.TRIV( :, 2 ), shape.TRIV( :, 2 ), shape.TRIV( :, 3 ), shape.TRIV( :, 3 )];
    fprintf(fout, 'f %d/%d %d/%d %d/%d\n', shape.TRIV');
end

fclose(fout);
