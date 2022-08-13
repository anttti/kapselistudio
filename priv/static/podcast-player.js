import {
  LitElement,
  html,
  css,
} from "https://unpkg.com/lit-element@3.2.0/lit-element.js?module";

class PodcastPlayer extends LitElement {
  static get properties() {
    return {
      currentTime: { type: String },
      currentSpeedIdx: { type: Number },
      duration: { type: String },
      title: { type: String },
      number: { type: String },
    };
  }

  static get styles() {
    return css`
      .podcast-player {
        background: var(--player-background, rgb(255 255 255 / 0.2));
        display: grid;
        grid-template-columns: 1fr;
        gap: 0.5rem 1rem;
        width: 100%;
        padding: 1rem;
        box-sizing: border-box;
        border-radius: 3px;
      }
      @media (min-width: 500px) {
        .podcast-player {
          grid-template-columns: 1fr 1fr 1fr;
          grid-template-rows: 3rem 1.5rem 3rem;
        }
      }
      .sr-only {
        position: absolute;
        width: 1px;
        height: 1px;
        padding: 0;
        margin: -1px;
        overflow: hidden;
        clip: rect(0, 0, 0, 0);
        border: 0;
      }
      button,
      span {
        padding: 0.5rem;
        display: block;
        line-height: 1;
        font-size: 1.5rem;
        text-shadow: 1px 1px var(--text-shadow);
      }
      span {
        align-self: center;
      }
      :focus-visible {
        outline: none;
        box-shadow: 0 0 0px 5px var(--player-focus);
      }
      button {
        -webkit-appearance: none;
        font-family: inherit;
        min-width: 26px;
        border: 1px solid transparent;
        background-color: transparent;
        border-radius: 3px;
        cursor: pointer;
        color: currentColor;
      }
      button svg {
        width: 2rem;
        height: 2rem;
      }
      .button-play {
        background: var(--player-highlight);
        height: 50px;
      }
      .button-secondary {
        border-color: var(--player-highlight);
      }
      .button-secondary:focus-visible {
        border-color: var(--player-focus);
      }
      @media (min-width: 500px) {
        .progress-meter {
          grid-row: 2;
          grid-column: 1 / -1;
        }
      }
      input[type="range"] {
        -webkit-appearance: none;
        width: 100%;
        background: transparent;
      }
      input[type="range"]::-webkit-slider-runnable-track {
        width: 100%;
        height: 0.5rem;
        cursor: pointer;
        animate: 0.2s;
        border: 1px solid var(--player-highlight);
        border-radius: 3px;
      }
      /* This is super weird, but combining this selector with the one
         above results in Safari not rendering the track. Similar
         case with the slider thumb below. */
      input[type="range"]::-moz-range-track {
        width: 100%;
        height: 0.5rem;
        cursor: pointer;
        animate: 0.2s;
        border: 1px solid var(--player-highlight);
        border-radius: 3px;
      }
      input[type="range"]::-webkit-slider-thumb {
        border: none;
        height: 15px;
        width: 15px;
        border-radius: 3px;
        background: var(--player-highlight);
        cursor: pointer;
        -webkit-appearance: none;
        margin-top: -0.25rem;
      }
      input[type="range"]::-moz-range-thumb {
        border: none;
        height: 15px;
        width: 15px;
        border-radius: 3px;
        background: var(--player-highlight);
        cursor: pointer;
        -webkit-appearance: none;
        margin-top: -0.25rem;
      }
      input[type="range"]::-ms-fill-lower {
        background: var(--player-highlight);
      }
      input[type="range"]::-ms-fill-upper {
        background: white;
      }
      .time {
        text-align: center;
      }
      @media (min-width: 500px) {
        .button-play {
          height: auto;
        }
        .time {
          text-align: left;
        }
        .duration {
          grid-column: 3;
          justify-self: end;
        }
        .button-speed {
          min-width: 3em;
          grid-column: 2;
          grid-row: 3;
        }
      }
      .button-speed:after {
        content: "x";
      }
      .button-play .pause {
        display: none;
      }
      :host(.is-playing) .button-play .pause {
        display: inline;
      }
      :host(.is-playing) .button-play .play {
        display: none;
      }
    `;
  }

  constructor() {
    super();

    // HTMLAudioElement
    this.audio = this.querySelector("audio");
    this.audio.controls = false;

    this.speeds = [1, 1.25, 1.5, 1.75, 2];
    this.currentSpeedIdx = 0;
    this.currentTime = 0;
    this.duration = 0;
    this.title = this.dataset.title;
    this.number = this.dataset.number;

    this.audio.addEventListener("timeupdate", this.handleTimeUpdate.bind(this));
    this.audio.addEventListener(
      "loadedmetadata",
      this.handleLoadedMetadata.bind(this)
    );
  }

  handleLoadedMetadata() {
    this.duration = this.audio.duration;
  }

  handleTimeUpdate(e) {
    this.currentTime = this.audio.currentTime;
  }

  toDurationString(secondsStr) {
    const pad = (num) => {
      const paddedString = `0${num}`;
      return paddedString.substring(paddedString.length - 2);
    };
    const seconds = parseInt(secondsStr, 10);
    const hh = Math.floor(seconds / (60 * 60));
    const remain = seconds % (60 * 60);
    const mm = Math.floor(remain / 60);
    const ss = Math.floor(remain % 60);
    return `${pad(hh)}:${pad(mm)}:${pad(ss)}`;
  }

  getSrc() {
    return this.audio.src;
  }

  setEpisode({ src, number, title }) {
    this.number = number;
    this.title = title;
    this.audio.src = src;
  }

  changeSpeed() {
    this.currentSpeedIdx =
      this.currentSpeedIdx + 1 < this.speeds.length
        ? this.currentSpeedIdx + 1
        : 0;
    this.audio.playbackRate = this.speeds[this.currentSpeedIdx];
  }

  rewind() {
    this.audio.currentTime -= 30;
  }

  ff() {
    this.audio.currentTime += 30;
  }

  isPaused() {
    return this.audio.paused;
  }

  play() {
    if (this.audio.paused) {
      this.audio.play();
      this.classList.add("is-playing");
    } else {
      this.audio.pause();
      this.classList.remove("is-playing");
    }
  }

  seek(e) {
    this.audio.currentTime = e.target.value;
  }

  render() {
    return html`
      <h1>${this.number}: ${this.title}</h1>
      <svg style="display: none;">
        <symbol id="icon-play" viewBox="0 0 15 27">
          <path
            fill="var(--player-focus)"
            d="M3 0H0V27H3V24H6V21H9V18H12V15H15V12H12V9H9V6H6V3H3V0Z"
          />
        </symbol>
        <symbol id="icon-pause" viewBox="0 0 15 21">
          <path fill="var(--player-focus)" d="M0 21V0H6V21H0Z" />
          <path fill="var(--player-focus)" d="M15 0H9V21H15V0Z" />
        </symbol>
      </svg>
      <div class="podcast-player">
        <button class="button-play" aria-label="Toista" @click="${this.play}">
          <svg class="play"><use xlink:href="#icon-play"></use></svg>
          <svg class="pause"><use xlink:href="#icon-pause"></use></svg>
        </button>
        <button
          class="button-secondary"
          aria-label="30 sekuntia taaksepäin"
          @click="${this.rewind}"
        >
          -30s
        </button>
        <button
          class="button-secondary"
          aria-label="30 sekuntia eteenpäin"
          @click="${this.ff}"
        >
          +30s
        </button>
        <span class="sr-only">Toistettu</span>
        <span class="time">${this.toDurationString(this.currentTime)}</span>
        <input
          type="range"
          class="progress-meter"
          value="${this.currentTime}"
          max="${this.duration}"
          @click="${this.seek}"
        />
        <span class="sr-only">Kesto</span>
        <span class="duration time"
          >${this.toDurationString(this.duration)}</span
        >
        <button
          class="button-speed button-secondary"
          @click="${this.changeSpeed}"
        >
          ${this.speeds[this.currentSpeedIdx]}
        </button>
      </div>
    `;
  }
}

customElements.define("podcast-player", PodcastPlayer);
