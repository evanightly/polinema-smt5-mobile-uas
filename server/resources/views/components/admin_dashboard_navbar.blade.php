<div class="shadow navbar bg-base-100">
    <div class="flex-1">
        <label for="dashboard-sidebar" class="btn btn-primary drawer-button lg:hidden">Open Sidebar</label>
        <a class="text-xl btn btn-ghost">Dashboard</a>
    </div>
    <label class="btn btn-ghost btn-circle swap swap-rotate">
        <input id="theme-toggle" type="checkbox" />
        <i class="text-lg text-yellow-300 fill-current swap-on fa-solid fa-sun"></i>
        <i class="text-lg text-blue-500 fill-current swap-off fa-solid fa-moon"></i>
    </label>
    <div class="flex-none">
        <div class="dropdown dropdown-end">
            <label tabindex="0" class="">
                <div class="flex items-center gap-2 pr-4 rounded-full hover:bg-base-200">
                    <btn class="btn btn-ghost btn-circle avatar">
                        <div class="w-10 rounded-full">
                            <img alt="User Profile" src="{{ auth()->user()->image_url }}" />
                        </div>
                    </btn>
                    <p>{{ auth()->user()->name }}</p>

                </div>
            </label>
            <ul tabindex="0" class="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-52">
                <li>
                    <a href="{{ route('settings.profile') }}" class="justify-between">
                        Profile
                        @if (auth()->user()->is_super_admin)
                            <span class="badge badge-primary">Super Admin</span>
                        @else
                            <span class="badge badge-secondary">Admin</span>
                        @endif
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
