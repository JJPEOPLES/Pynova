"""
Create a dummy numba module to allow the IDE to run without numba installed.
"""

import os

# Path to the dummy numba module
dummy_numba_path = os.path.join('pynova_core', 'dummy_numba.py')

# Create the dummy numba module
with open(dummy_numba_path, 'w') as f:
    f.write('''# Dummy numba module
# This is used when the real numba package is not installed

def jit(func=None, *args, **kwargs):
    """
    A dummy implementation of numba.jit that just returns the function.
    
    This allows the code to run without numba installed, but without JIT optimization.
    """
    # Handle both @jit and @jit() decorator forms
    if func is None:
        # This is the @jit() form
        def decorator(function):
            return function
        return decorator
    
    # This is the @jit form
    return func
''')

print(f"Created dummy numba module at {dummy_numba_path}")