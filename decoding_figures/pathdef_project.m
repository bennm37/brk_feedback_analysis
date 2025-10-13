function p = pathdef_project()
    % PATHDEF_PROJECT Set paths for MyProject
    %
    % Adds project-specific directories to the MATLAB path.

    % Get the root directory of the project
    rootDir = fileparts(mfilename('fullpath'));

    % List of subdirectories to add
    subdirs = { ...
        'src',
    };

    % Build full paths
    paths = cellfun(@(subdir) fullfile(rootDir, subdir), subdirs, 'UniformOutput', false);

    % Convert to a semicolon-separated string
    p = strjoin(paths, pathsep);
end