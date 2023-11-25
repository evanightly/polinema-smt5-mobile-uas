<div class="navbar bg-base-100 shadow">
    <div class="flex-1">
        <label for="dashboard-sidebar" class="btn btn-primary drawer-button lg:hidden">Open Sidebar</label>
        <a class="btn btn-ghost text-xl">Dashboard</a>
    </div>
    <label class="btn btn-ghost btn-circle swap swap-rotate">
        <input id="theme-toggle" type="checkbox" />
        <i class="swap-on fill-current text-lg text-yellow-300 fa-solid fa-sun"></i>
        <i class="swap-off fill-current text-lg text-blue-500 fa-solid fa-moon"></i>
    </label>
    <div class="flex-none">
        <div class="dropdown dropdown-end">
            <label tabindex="0" class="btn btn-ghost btn-circle avatar">
                <div class="w-10 rounded-full">
                    <img alt="User Profile" src="{{ auth()->user()->imageUrl }}" />
                </div>
            </label>
            <ul tabindex="0" class="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-52">
                <li>
                    <a class="justify-between">
                        Profile
                        <span class="badge">New</span>
                    </a>
                </li>
                <li>
                    <form action="{{ route('logout') }}" method="post" class="flex">
                        @csrf
                        <button type="submit" class="w-full text-left">Logout</button>
                    </form>
                </li>
            </ul>
        </div>
    </div>
</div>
