import unittest
import numpy as np
from numpy.testing import assert_allclose
from problems import integrator_control_problem, bang_bang_problem
from casadi import vertcat, DM
from rockit import MultipleShooting, DirectCollocation, Ocp

class OcpSolutionTests(unittest.TestCase):
    def test_grid_integrator(self):
        N, T, u_max, x0 = 10, 10, 2, 1
        tolerance = 1e-6
        ocp, x, u = integrator_control_problem(T, u_max, x0, MultipleShooting(N=N,M=3,intg='rk'))
        sol = ocp.solve()
        ts, xs = sol.sample(x, grid='integrator')
        ts, us = sol.sample(u, grid='integrator')
        ts, uxs = sol.sample(u * x, grid='integrator')

        t_exact = np.linspace(0, T, N * 3 + 1)
        x_exact = np.linspace(1, x0 - 10 * u_max, N * 3 + 1)
        u_exact = np.ones(N * 3 + 1) * (-u_max)

        assert_allclose(ts, t_exact, atol=tolerance)
        assert_allclose(xs, x_exact, atol=tolerance)
        assert_allclose(us, u_exact, atol=tolerance)
        assert_allclose(uxs, u_exact * x_exact, atol=tolerance)


        tsa, tsb = sol.sample(ocp.t, grid='integrator')
        assert_allclose(tsa, tsb, atol=tolerance)

    def test_intg_refine(self):
        for M in [1, 2]:
          for method in [DirectCollocation(N=2,M=M), MultipleShooting(N=2,M=M,intg='rk')]:
            ocp, sol, p, v, u = bang_bang_problem(method)
            tolerance = 1e-6

            ts, ps = sol.sample(p, grid='integrator', refine=10)

            ps_ref = np.hstack(((0.5*np.linspace(0,1, 10*M+1)**2)[:-1],np.linspace(0.5,1.5,10*M+1)-0.5*np.linspace(0,1, 10*M+1)**2)) 
            assert_allclose(ps, ps_ref, atol=tolerance)

            ts_ref = np.linspace(0, 2, 10*2*M+1)
            assert_allclose(ts, ts_ref, atol=tolerance)

            ts, vs = sol.sample(v, grid='integrator', refine=10)
            assert_allclose(ts, ts_ref, atol=tolerance)

            vs_ref = np.hstack((np.linspace(0,1, 10*M+1)[:-1],np.linspace(1,0, 10*M+1))) 
            assert_allclose(vs, vs_ref, atol=tolerance)


            u_ref = np.array([1.0]*M*10+[-1.0]*(M*10+1))
            ts, us = sol.sample(u, grid='integrator', refine=10)
            assert_allclose(us, u_ref, atol=tolerance)

    def test_shapes(self):
      ocp = Ocp(T=1)
      N = 3
      M = 5
      R = 2
      for xshape in [(), (7,), (7, 11), (1, 1), (7, 1), (1, 7)]:
        target_shape = tuple([e for e in xshape if e!=1])
        x = ocp.state(*xshape)
        ocp.set_der(x,DM.ones(*xshape))
        X0 = DM.rand(*xshape)
        ocp.subject_to(ocp.at_t0(x)==X0)
        ocp.solver('ipopt')

        X0_target = np.array(X0).reshape(target_shape)

        degree = 2
        ocp.method(DirectCollocation(N=N,M=M,degree=2))
        
        sol = ocp.solve()
        
        t, X = sol.sample(x,grid='control')
        tdim = N+1
        self.assertEqual(t.shape[0],tdim)
        self.assertEqual(X.shape[0],tdim)
        assert_allclose(X.shape[1:],target_shape)
        for i in range(tdim):
          assert_allclose(X[i,...],X0_target+t[i])

        t, X = sol.sample(x,grid='integrator')
        tdim = N*M+1
        self.assertEqual(t.shape[0],tdim)
        self.assertEqual(X.shape[0],tdim)
        assert_allclose(X.shape[1:],target_shape)
        for i in range(tdim):
          assert_allclose(X[i,...],X0_target+t[i])

        t, X = sol.sample(x,grid='integrator',refine=R)
        tdim = N*M*R+1
        self.assertEqual(t.shape[0],tdim)
        self.assertEqual(X.shape[0],tdim)
        for i in range(tdim):
          assert_allclose(X[i,...],X0_target+t[i])


        t, X = sol.sample(x,grid='integrator_roots')
        tdim = N*M*degree
        self.assertEqual(t.shape[0],tdim)
        self.assertEqual(X.shape[0],tdim)
        for i in range(tdim):
          assert_allclose(X[i,...],X0_target+t[i])

if __name__ == '__main__':
    unittest.main()
