classdef SplineMethod < rockit.DirectMethod
  properties
  end
  methods
    function obj = SplineMethod(varargin)
      obj@rockit.DirectMethod('from_super');
      if length(varargin)==1 && ischar(varargin{1}) && strcmp(varargin{1},'from_super'),return,end
      if length(varargin)==1 && isa(varargin{1},'py.rockit.spline_method.SplineMethod')
        obj.parent = varargin{1};
        return
      end
      global pythoncasadiinterface
      if isempty(pythoncasadiinterface)
        pythoncasadiinterface = rockit.PythonCasadiInterface;
      end
      [args,kwargs] = pythoncasadiinterface.matlab2python_arg(varargin,0,{'kwargs'});
      if isempty(kwargs)
        obj.parent = py.rockit.SplineMethod(args{:});
      else
        obj.parent = py.rockit.SplineMethod(args{:},pyargs(kwargs{:}));
      end
    end
    function varargout = transcribe_start(obj,varargin)
      global pythoncasadiinterface
      [args,kwargs] = pythoncasadiinterface.matlab2python_arg(varargin,2,{'stage','opti'});
      if isempty(kwargs)
        res = obj.parent.transcribe_start(args{:});
      else
        res = obj.parent.transcribe_start(args{:},pyargs(kwargs{:}));
      end
      varargout = pythoncasadiinterface.python2matlab_ret(res);
    end
    function varargout = sample_xu(obj,varargin)
      global pythoncasadiinterface
      [args,kwargs] = pythoncasadiinterface.matlab2python_arg(varargin,2,{'stage','refine'});
      if isempty(kwargs)
        res = obj.parent.sample_xu(args{:});
      else
        res = obj.parent.sample_xu(args{:},pyargs(kwargs{:}));
      end
      varargout = pythoncasadiinterface.python2matlab_ret(res);
    end
    function varargout = add_variables(obj,varargin)
      global pythoncasadiinterface
      [args,kwargs] = pythoncasadiinterface.matlab2python_arg(varargin,2,{'stage','opti'});
      if isempty(kwargs)
        res = obj.parent.add_variables(args{:});
      else
        res = obj.parent.add_variables(args{:},pyargs(kwargs{:}));
      end
      varargout = pythoncasadiinterface.python2matlab_ret(res);
    end
    function varargout = grid_gist(obj,varargin)
      global pythoncasadiinterface
      [args,kwargs] = pythoncasadiinterface.matlab2python_arg(varargin,3,{'stage','expr','grid','include_first','include_last','transpose','refine'});
      if isempty(kwargs)
        res = obj.parent.grid_gist(args{:});
      else
        res = obj.parent.grid_gist(args{:},pyargs(kwargs{:}));
      end
      varargout = pythoncasadiinterface.python2matlab_ret(res);
    end
    function varargout = grid_control(obj,varargin)
      global pythoncasadiinterface
      [args,kwargs] = pythoncasadiinterface.matlab2python_arg(varargin,3,{'stage','expr','grid','include_first','include_last','transpose','refine'});
      if isempty(kwargs)
        res = obj.parent.grid_control(args{:});
      else
        res = obj.parent.grid_control(args{:},pyargs(kwargs{:}));
      end
      varargout = pythoncasadiinterface.python2matlab_ret(res);
    end
    function varargout = add_constraints(obj,varargin)
      global pythoncasadiinterface
      [args,kwargs] = pythoncasadiinterface.matlab2python_arg(varargin,2,{'stage','opti'});
      if isempty(kwargs)
        res = obj.parent.add_constraints(args{:});
      else
        res = obj.parent.add_constraints(args{:},pyargs(kwargs{:}));
      end
      varargout = pythoncasadiinterface.python2matlab_ret(res);
    end
    function varargout = xu_symbols(obj,varargin)
      global pythoncasadiinterface
      [args,kwargs] = pythoncasadiinterface.matlab2python_arg(varargin,3,{'stage','v_indices','pool'});
      if isempty(kwargs)
        res = obj.parent.xu_symbols(args{:});
      else
        res = obj.parent.xu_symbols(args{:},pyargs(kwargs{:}));
      end
      varargout = pythoncasadiinterface.python2matlab_ret(res);
    end
    function varargout = add_constraints_noninf(obj,varargin)
      global pythoncasadiinterface
      [args,kwargs] = pythoncasadiinterface.matlab2python_arg(varargin,2,{'stage','opti'});
      if isempty(kwargs)
        res = obj.parent.add_constraints_noninf(args{:});
      else
        res = obj.parent.add_constraints_noninf(args{:},pyargs(kwargs{:}));
      end
      varargout = pythoncasadiinterface.python2matlab_ret(res);
    end
    function varargout = add_constraints_inf(obj,varargin)
      global pythoncasadiinterface
      [args,kwargs] = pythoncasadiinterface.matlab2python_arg(varargin,2,{'stage','opti'});
      if isempty(kwargs)
        res = obj.parent.add_constraints_inf(args{:});
      else
        res = obj.parent.add_constraints_inf(args{:},pyargs(kwargs{:}));
      end
      varargout = pythoncasadiinterface.python2matlab_ret(res);
    end
    function varargout = set_initial(obj,varargin)
      global pythoncasadiinterface
      [args,kwargs] = pythoncasadiinterface.matlab2python_arg(varargin,3,{'stage','master','initial'});
      if isempty(kwargs)
        res = obj.parent.set_initial(args{:});
      else
        res = obj.parent.set_initial(args{:},pyargs(kwargs{:}));
      end
      varargout = pythoncasadiinterface.python2matlab_ret(res);
    end
    function out = internal__module__(obj)
      % str(object='') -> str
      % str(bytes_or_buffer[, encoding[, errors]]) -> str
      % 
      % Create a new string object from the given object. If encoding or
      % errors is specified, then the object must expose a data buffer
      % that will be decoded using the given encoding and error handler.
      % Otherwise, returns the result of object.__str__() (if defined)
      % or repr(object).
      % encoding defaults to sys.getdefaultencoding().
      % errors defaults to 'strict'.
      global pythoncasadiinterface
      out = pythoncasadiinterface.python2matlab(obj.parent.internal__module__);
    end
    function out = internal__doc__(obj)
      global pythoncasadiinterface
      out = pythoncasadiinterface.python2matlab(obj.parent.internal__doc__);
    end
  end
end
